import 'package:id_form/core/stores/error/error_store.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';
import 'package:id_form/domain/usecase/id_form/insert_id_form_usecase.dart';
import 'package:id_form/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'id_form_store.g.dart';

class IDFormStore = _IDFormStore with _$IDFormStore;

abstract class _IDFormStore with Store {
  // constructor:---------------------------------------------------------------
  _IDFormStore(this._inseIDFormUseCase, this.errorStore);

  // use cases:-----------------------------------------------------------------
  final InsertIDFormUseCase _inseIDFormUseCase;

  // stores:--------------------------------------------------------------------
  // store for handling errors
  final ErrorStore errorStore;

  // store variables:-----------------------------------------------------------
  static ObservableFuture emptyInsertIDFormResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture insertIDFormFuture =
      ObservableFuture(emptyInsertIDFormResponse);

  @observable
  IDForm? idFrom;

  @observable
  bool success = false;

  @computed
  bool get loading => insertIDFormFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future postIDForm() async {
    final future = _inseIDFormUseCase.call(params: idFrom!);
    insertIDFormFuture = ObservableFuture(future);

    future.then((res) {
      
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
