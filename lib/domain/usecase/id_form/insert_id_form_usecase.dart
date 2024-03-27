import 'package:id_form/core/domain/usecase/use_case.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';
import 'package:id_form/domain/repository/id_form/post_repository.dart';

class InsertIDFormUseCase extends UseCase<dynamic, IDForm> {
  final IDFormRepository _idFormRepository;

  InsertIDFormUseCase(this._idFormRepository);

  @override
  Future call({required params}) {
    return _idFormRepository.insert(params);
  }
}
