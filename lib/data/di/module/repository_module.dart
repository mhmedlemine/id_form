import 'dart:async';

import 'package:id_form/data/network/apis/id_form/id_form_api.dart';
import 'package:id_form/data/repository/post/post_repository_impl.dart';
import 'package:id_form/data/repository/setting/setting_repository_impl.dart';
import 'package:id_form/data/repository/user/user_repository_impl.dart';
import 'package:id_form/data/sharedpref/shared_preference_helper.dart';
import 'package:id_form/domain/repository/id_form/post_repository.dart';
import 'package:id_form/domain/repository/setting/setting_repository.dart';
import 'package:id_form/domain/repository/user/user_repository.dart';

import '../../../di/service_locator.dart';

mixin RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    getIt.registerSingleton<SettingRepository>(SettingRepositoryImpl(
      getIt<SharedPreferenceHelper>(),
    ));

    getIt.registerSingleton<UserRepository>(UserRepositoryImpl(
      getIt<SharedPreferenceHelper>(),
    ));

    getIt.registerSingleton<IDFormRepository>(IDFormRepositoryImpl(
      getIt<IDFormApi>(),
    ));
  }
}
