// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IDFormStore on _IDFormStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_IDFormStore.loading'))
      .value;

  late final _$insertIDFormFutureAtom =
      Atom(name: '_IDFormStore.insertIDFormFuture', context: context);

  @override
  ObservableFuture<dynamic> get insertIDFormFuture {
    _$insertIDFormFutureAtom.reportRead();
    return super.insertIDFormFuture;
  }

  @override
  set insertIDFormFuture(ObservableFuture<dynamic> value) {
    _$insertIDFormFutureAtom.reportWrite(value, super.insertIDFormFuture, () {
      super.insertIDFormFuture = value;
    });
  }

  late final _$idFromAtom = Atom(name: '_IDFormStore.idFrom', context: context);

  @override
  IDForm? get idFrom {
    _$idFromAtom.reportRead();
    return super.idFrom;
  }

  @override
  set idFrom(IDForm? value) {
    _$idFromAtom.reportWrite(value, super.idFrom, () {
      super.idFrom = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_IDFormStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$postIDFormAsyncAction =
      AsyncAction('_IDFormStore.postIDForm', context: context);

  @override
  Future<dynamic> postIDForm() {
    return _$postIDFormAsyncAction.run(() => super.postIDForm());
  }

  @override
  String toString() {
    return '''
insertIDFormFuture: ${insertIDFormFuture},
idFrom: ${idFrom},
success: ${success},
loading: ${loading}
    ''';
  }
}
