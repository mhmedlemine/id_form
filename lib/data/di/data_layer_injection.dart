import 'package:id_form/data/di/module/local_module.dart';
import 'package:id_form/data/di/module/network_module.dart';
import 'package:id_form/data/di/module/repository_module.dart';

mixin DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await LocalModule.configureLocalModuleInjection();
    await NetworkModule.configureNetworkModuleInjection();
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}
