import 'dart:async';

import 'package:id_form/core/data/network/dio/dio_client.dart';
import 'package:id_form/data/network/constants/endpoints.dart';
import 'package:id_form/data/network/rest_client.dart';
import 'package:id_form/domain/entity/id_form/id_form.dart';

class IDFormApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  IDFormApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future postIDForm(IDForm form) async {
    try {
      final res = await _dioClient.dio.post(
        Endpoints.postIdForm,
        data: form.toJson(),
      );
      return res.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

/// sample api call with default rest client
//  Future<IDFormsList> getIDForms() {
//
//    return _restClient
//        .get(Endpoints.getIDForms)
//        .then((dynamic res) => IDFormsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
