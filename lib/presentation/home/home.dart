import 'dart:async';

import 'dart:math' as math;
import 'package:id_form/data/sharedpref/constants/preferences.dart';
import 'package:id_form/di/service_locator.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';
import 'package:id_form/presentation/home/store/language/language_store.dart';
import 'package:id_form/presentation/home/store/theme/theme_store.dart';
import 'package:id_form/presentation/id_form/id_form.dart';
import 'package:id_form/presentation/id_form/store/id_form_store.dart';
import 'package:id_form/presentation/mrz_scanner/mrz_scanner.dart';
import 'package:id_form/utils/locale/app_localization.dart';
import 'package:id_form/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();
  final IDFormStore _idFormStore = getIt<IDFormStore>();

  MRZResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IDFormScreen(),
    );
  }

  Widget navigate() {
    Future.delayed(Duration(milliseconds: 0), () {
      
    });

    return Container();
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_form')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildScanButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildScanButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => MrzScannerScreen()));
        //Navigator.of(context).pushNamed(Routes.mrzScanner);
        _idFormStore.idFrom = IDForm(
          nni: result?.personalNumber,
          fname: result?.givenNames,
          lname: result?.surnames,
          sex: SexType.values.elementAt(result?.sex.index ?? 0),
          birthDate: result?.birthDate,
          countryCode: result?.countryCode,
          expiryDate: result?.expiryDate,
          nationalityCountryCode: result?.nationalityCountryCode,
        );
      },
      label: Text('Scan ID'),
      icon: Transform.rotate(
        angle: 45 * math.pi / 180,
        child: Icon(
          Icons.control_camera_outlined,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.logout,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale!);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
