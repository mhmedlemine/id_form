import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'package:id_form/core/widgets/empty_app_bar_widget.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:mrz_parser/mrz_parser.dart';

class MrzScannerScreen extends StatefulWidget {
  const MrzScannerScreen({Key? key,})
      : super(key: key);

  @override
  MrzScannerScreenState createState() => MrzScannerScreenState();
}

class MrzScannerScreenState extends State<MrzScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextRecognizer _textRecognizer = TextRecognizer();
  final cameraPrev = GlobalKey();
  final thePainter = GlobalKey();

  final bool _canProcess = true;
  bool _isBusy = false;
  bool converting = false;
  CameraController? _controller;
  FlashMode _flashMode = FlashMode.off;
  late List<CameraDescription> _cameras;
  double zoomLevel = 3.0, minZoomLevel = 0.0, maxZoomLevel = 10.0;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: EmptyAppBar(),
      body: _liveFeedBodyy(),
    );
  }

  // Body of live camera stream
  Widget _liveFeedBodyy() {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Tap a camera');
    } else {
      return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(_controller!),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9),
                BlendMode.srcOut,
              ), // This one will create the magic
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ), // This one will handle background + difference out
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * .5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .28,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * .5,
              left: MediaQuery.of(context).size.width * .05,
              child: Container(
                height: MediaQuery.of(context).size.height * .28,
                width: MediaQuery.of(context).size.width,
                
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * .4,
              left: MediaQuery.of(context).size.width * .1,
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Text(
                  "Put Back of ID inside rectangle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * .05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: Localizations.localeOf(context).languageCode == 'ar'
                  ? null
                  : 20,
              right: Localizations.localeOf(context).languageCode == 'ar'
                  ? 20
                  : null,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.grey[800]),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: Localizations.localeOf(context).languageCode != 'ar'
                  ? null
                  : 20,
              right: Localizations.localeOf(context).languageCode != 'ar'
                  ? 20
                  : null,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _flashMode = _flashMode == FlashMode.off
                        ? FlashMode.torch
                        : FlashMode.off;
                    _onSetFlashModeButtonPressed(_flashMode);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _flashMode == FlashMode.off
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            
          ],
        );
    }
  }

  void _onSetFlashModeButtonPressed(FlashMode mode) {
    _setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _setFlashMode(FlashMode mode) async {
    if (_controller == null) {
      return;
    }

    try {
      await _controller?.setFlashMode(mode);
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }

  // Start camera stream function
  Future startLiveFeed() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    final camera = _cameras[0];
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21 // for Android
              : ImageFormatGroup.bgra8888, // for iOS
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            log('User denied camera access.');
            break;
          default:
            log('Handle other errors.');
            break;
        }
      }
    });
  }

    // Process image from camera stream
  void _processCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = _cameras[0];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
            (Platform.isAndroid && format != InputImageFormat.nv21) ||
            (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    final inputImage = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    processImage(inputImage);
  }

  // Stop camera live stream
  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  // Process image
  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final recognizedText = await _textRecognizer.processImage(inputImage);
    
    List textBlocks = [];
    String scannedText = "";
    for (final textBunk in recognizedText.blocks) {
      for (final element in textBunk.lines) {
        for (final textBlock in element.elements) {          
          textBlocks.add(textBlock);
          scannedText += " ${textBlock.text}";
        }
      }
    }

    _scanMrzCode(scannedText);

    Future.delayed(const Duration(milliseconds: 900)).then((value) {
      if (!converting) {
        _isBusy = false;
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  int tries = 0;
  String? _extractMrz(String scannedText) {
    int mrzCodeLength = 90;
    
    scannedText = scannedText.replaceAll(' ', '');
    final mrzStartIndex = scannedText.indexOf('I<MRT');
    
    if (mrzStartIndex == -1) {
      tries++;
      return null;
    }

    final mrzCodeWithRest = scannedText.substring(mrzStartIndex);
    if (mrzCodeWithRest.length < mrzCodeLength) {
      tries++;
      return null;
    }

    return mrzCodeWithRest.substring(0, mrzCodeLength);
  }

  void _scanMrzCode(String scannedText) {
    final mrzCode = _extractMrz(scannedText);
    if (mrzCode == null) {
      if(tries %3 == 0) {
        _buildFlushBar("Impossible de détecter l'arrière de la pièce d'identité");
      }
      return;
    }

    if (mrzCode.length == 90) {
      List<String> mrz = [];
      mrz.add(mrzCode.substring(0, 30));
      mrz.add(mrzCode.substring(30, 60));
      mrz.add(mrzCode.substring(60, 90));

      try {
        final result = MRZParser.parse(mrz);
        Navigator.of(context).pop(result);
      } on MRZException catch(e) {
        _buildFlushBar(e.message);
      }
    }
  }

  _buildFlushBar(String msg) {
    FlushbarHelper.createError(message: msg)..show(context);
  }
}
