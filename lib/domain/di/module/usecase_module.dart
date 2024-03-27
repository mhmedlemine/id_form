import 'dart:async';

import 'package:id_form/domain/repository/id_form/post_repository.dart';
import 'package:id_form/domain/repository/user/user_repository.dart';
import 'package:id_form/domain/usecase/id_form/insert_id_form_usecase.dart';
import 'package:id_form/domain/usecase/user/is_logged_in_usecase.dart';
import 'package:id_form/domain/usecase/user/login_usecase.dart';
import 'package:id_form/domain/usecase/user/save_login_in_status_usecase.dart';

import '../../../di/service_locator.dart';

mixin UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // user:--------------------------------------------------------------------
    getIt.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<SaveLoginStatusUseCase>(
      SaveLoginStatusUseCase(getIt<UserRepository>()),
    );
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<UserRepository>()),
    );

    // id form:--------------------------------------------------------------------
    getIt.registerSingleton<InsertIDFormUseCase>(
      InsertIDFormUseCase(getIt<IDFormRepository>()),
    );
  }
}
