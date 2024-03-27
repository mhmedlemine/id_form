import 'dart:async';

import 'package:id_form/domain/entity/id_form/id_form.dart';

abstract class IDFormRepository {
  Future insert(IDForm post);
}
