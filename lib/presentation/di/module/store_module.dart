import 'dart:async';

import 'package:id_form/core/stores/error/error_store.dart';
import 'package:id_form/core/stores/form/form_store.dart';
import 'package:id_form/domain/repository/setting/setting_repository.dart';
import 'package:id_form/domain/usecase/id_form/insert_id_form_usecase.dart';
import 'package:id_form/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:id_form/domain/usecase/user/login_usecase.dart';
import 'package:id_form/domain/usecase/user/save_login_in_status_usecase.dart';
import 'package:id_form/presentation/home/store/language/language_store.dart';
import 'package:id_form/presentation/home/store/theme/theme_store.dart';
import 'package:id_form/presentation/id_form/store/id_form_store.dart';
import 'package:id_form/presentation/login/store/login_store.dart';

import '../../../di/service_locator.dart';

mixin StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());
    getIt.registerFactory(() => FormErrorStore());
    getIt.registerFactory(
      () => FormStore(getIt<FormErrorStore>(), getIt<ErrorStore>()),
    );

    // stores:------------------------------------------------------------------
    getIt.registerSingleton<UserStore>(
      UserStore(
        getIt<IsLoggedInUseCase>(),
        getIt<SaveLoginStatusUseCase>(),
        getIt<LoginUseCase>(),
        getIt<FormErrorStore>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<IDFormStore>(
      IDFormStore(
        getIt<InsertIDFormUseCase>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );
  }
}
