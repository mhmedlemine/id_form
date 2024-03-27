import 'package:another_flushbar/flushbar_helper.dart';
import 'package:id_form/core/stores/form/form_store.dart';
import 'package:id_form/core/widgets/progress_indicator_widget.dart';
import 'package:id_form/core/widgets/rounded_button_widget.dart';
import 'package:id_form/core/widgets/textfield_widget.dart';
import 'package:id_form/di/service_locator.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';
import 'package:id_form/presentation/home/store/theme/theme_store.dart';
import 'package:id_form/presentation/id_form/store/id_form_store.dart';
import 'package:id_form/utils/device/device_utils.dart';
import 'package:id_form/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';

class IDFormScreen extends StatefulWidget {
  @override
  _IDFormScreenState createState() => _IDFormScreenState();
}

class _IDFormScreenState extends State<IDFormScreen> {
  //stores:---------------------------------------------------------------------
  final IDFormStore _idFormStore = getIt<IDFormStore>();

  //text controllers:-----------------------------------------------------------
  TextEditingController _nniController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  DateTime _expiryDate = DateTime.now();
  int sex = 0;

  final genders = ["Homme", "Femme"];

  //stores:---------------------------------------------------------------------
  final FormStore _formStore = getIt<FormStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
        Observer(builder: (context) {
          return _idFormStore.idFrom != null ? fillData() : SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _idFormStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildLoginForm());
      },
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            Text('NNI'),
            _buildNNIField(),
            SizedBox(height: 8.0),
            Text('Prenom'),
            _buildFNameField(),
            SizedBox(height: 8.0),
            Text('Nom'),
            _buildLNameField(),
            SizedBox(height: 8.0),
            Text('Nationalite'),
            _buildCountryField(),
            SizedBox(height: 8.0),
            Text('Sexe'),
            _buildGenderField(),
            SizedBox(height: 8.0),
            Text('Date de naissance'),
            _buildBirthDateField(),
            SizedBox(height: 8.0),
            Text("Date d'expiration"),
            _buildExpiryDateField(),
            SizedBox(height: 24.0),
            _buildPostFromButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNNIField() {
    return TextFieldWidget(
      hint: 'NNI',
      inputType: TextInputType.number,
      icon: Icons.person,
      iconColor: Colors.black54,
      textController: _nniController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onChanged: (value) {
        if (_idFormStore.idFrom == null) {
          _idFormStore.idFrom = IDForm();
        }
        _idFormStore.idFrom?.nni = value;
      },
      onFieldSubmitted: (value) {
      },
      errorText: null,
    );
  }

  Widget _buildFNameField() {
    return TextFieldWidget(
      hint: 'Prenom',
      inputType: TextInputType.text,
      icon: Icons.person,
      iconColor: Colors.black54,
      textController: _fnameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onChanged: (value) {
        if (_idFormStore.idFrom == null) {
          _idFormStore.idFrom = IDForm();
        }
        _idFormStore.idFrom?.fname = value;
      },
      onFieldSubmitted: (value) {
      },
      errorText: null,
    );
  }

  Widget _buildLNameField() {
    return TextFieldWidget(
      hint: 'Nom',
      inputType: TextInputType.text,
      icon: Icons.person,
      iconColor: Colors.black54,
      textController: _lnameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onChanged: (value) {
        if (_idFormStore.idFrom == null) {
          _idFormStore.idFrom = IDForm();
        }
        _idFormStore.idFrom?.lname = value;
      },
      onFieldSubmitted: (value) {
      },
      errorText: null,
    );
  }

  Widget _buildCountryField() {
    return TextFieldWidget(
      hint: 'Nationalite',
      inputType: TextInputType.text,
      icon: Icons.person,
      iconColor: Colors.black54,
      textController: _countryController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onChanged: (value) {
        if (_idFormStore.idFrom == null) {
          _idFormStore.idFrom = IDForm();
        }
        _idFormStore.idFrom?.nationalityCountryCode = value;
      },
      onFieldSubmitted: (value) {
      },
      errorText: null,
    );      
  }

  Widget _buildGenderField() {
    return  GestureDetector(
      onTap: () async {
        final res = await buildSelectDialog(
          context: context,
          title: 'Selectionner Sexe',
          selected: sex,
        );
        if (res != null) {
          _sexController.text = genders[res];
          sex = res;
          if (_idFormStore.idFrom == null) {
            _idFormStore.idFrom = IDForm();
          }
          _idFormStore.idFrom?.sex = SexType.values.elementAt(res);
        }
      },
      child: TextFieldWidget(
        hint: 'Sexe',
        enabled: false,
        padding: EdgeInsets.only(top: 0.0),
        iconColor: Colors.black54,
        icon: Icons.male,
        textController: _sexController,
        suffix: Icon(Icons.arrow_drop_down_rounded),
        errorText: null,
      ),
    );
  }
  
  Widget _buildBirthDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_month,
              color: const Color.fromARGB(255, 100, 100, 100),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () async {
                final res = await showDatePicker(
                  context: context,
                  initialDate: _birthDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(Duration(days: 1)),
                );

                if (res != null) {
                  setState(() {
                    _birthDate = res;
                  });
                  if (_idFormStore.idFrom == null) {
                    _idFormStore.idFrom = IDForm();
                  }
                  _idFormStore.idFrom?.birthDate = _birthDate;
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .77,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    
                    Text(
                      "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_month,
              color: const Color.fromARGB(255, 100, 100, 100),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () async {
                final res = await showDatePicker(
                  context: context,
                  initialDate: _expiryDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(Duration(days: 10000)),
                );

                if (res != null) {
                  setState(() {
                    _expiryDate = res;
                  });
                  if (_idFormStore.idFrom == null) {
                    _idFormStore.idFrom = IDForm();
                  }
                  _idFormStore.idFrom?.expiryDate = _expiryDate;
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .77,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    
                    Text(
                      "${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostFromButton() {
    return RoundedButtonWidget(
      buttonText: 'Envoyer',
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () async {
        if (_idFormStore.idFrom != null) {
          DeviceUtils.hideKeyboard(context);
          await _idFormStore.postIDForm();
        } else {
          _showErrorMessage(AppLocalizations.of(context).translate('login_fill_all_fields'));
        }
      },
    );
  }

  Widget fillData() {
    Future.delayed(Duration(milliseconds: 0), () {
      if (_idFormStore.idFrom != null) {
        setState(() {
          _nniController.text = _idFormStore.idFrom?.nni ?? '';
          _fnameController.text = _idFormStore.idFrom?.fname ?? '';
          _lnameController.text = _idFormStore.idFrom?.lname ?? '';
          _countryController.text = _idFormStore.idFrom?.nationalityCountryCode ?? '';
          _sexController.text = genders[_idFormStore.idFrom?.sex?.index ?? 0];
          _birthDate = _idFormStore.idFrom?.birthDate ?? DateTime.now();
          _expiryDate = _idFormStore.idFrom?.expiryDate ?? DateTime.now();
          sex = _idFormStore.idFrom?.sex?.index ?? 0;
        });
      }
    });

    return Container();
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_idFormStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_idFormStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }



  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  Future<int?> buildSelectDialog({
    required BuildContext context,
    required String title,
    int? selected,
  }) async {
    return _showDialogAsync<int>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Theme.of(context).colorScheme.onSurface,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop(null);
        },
        children: SexType.values
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                leading: Icon(
                  object.index == selected
                      ? Icons.check_circle_outline_outlined
                      : Icons.circle_outlined,
                  color: object.index == selected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(genders[object.index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: object.index == selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(object.index);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  static Future<T?> _showDialogAsync<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => child,
    );
  }
}
