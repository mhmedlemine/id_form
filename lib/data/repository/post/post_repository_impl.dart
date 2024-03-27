import 'dart:async';

import 'package:id_form/data/network/apis/id_form/id_form_api.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';
import 'package:id_form/domain/repository/id_form/post_repository.dart';

class IDFormRepositoryImpl extends IDFormRepository {

  // api objects
  final IDFormApi _idFormApi;

  // constructor
  IDFormRepositoryImpl(this._idFormApi);

  // IDForm: ---------------------------------------------------------------------
  @override
  Future insert(IDForm idForm) => _idFormApi
      .postIDForm(idForm)
      .then((id) => id)
      .catchError((error) => throw error);
}
