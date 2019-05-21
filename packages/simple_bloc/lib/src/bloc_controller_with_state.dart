import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_controller.dart';

abstract class BlocControllerWithState<S extends BlocState> {

  S _state;
  S get state => _state;

  S get initialState;

  void registerState(S state) {
    _state = state;
    _state._registerController(this as BlocController);

    _state._subject.listen(onStateUpdate, onError: onStateError, onDone: onStateDone);
  }
  
  @protected
  void onStateUpdate(S data) {
    (this as BlocController).publishUpdate();
  }

  @protected
  void onStateError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  }

  @protected
  void onStateDone() => null;
}

abstract class BlocState {
  
  BlocState()
    : _subject = PublishSubject();

  final PublishSubject<BlocState> _subject;

  BlocController controller;

  StreamSink<BlocState> get sink => _subject.sink;
  Observable<BlocState> get stream => _subject.stream;

  void _registerController(BlocController controller) {
    this.controller = controller;
  }

  Future<void> mutate(void Function() mutation) async {
    try {
      preMutate();
      mutation();
      postMutate();

      _subject.add(this);
    } catch(e, st) {
      this.onError(e, st);
    }
  }

  @protected
  void onError(Object error, StackTrace stackTrace) => print(error);
  @protected
  void preMutate() => null;
  @protected
  void postMutate() => null;

}