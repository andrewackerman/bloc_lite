import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocController {

  BlocController([Key key]) : this.withState(null, key);
  BlocController.withState([BlocState state, Key key])
      : widgetKey = key,
        _subject = PublishSubject() {
    if (this is BlocControllerWithState) {
      if (state != null) {
        (this as BlocControllerWithState).registerState(state);
      } else {
        (this as BlocControllerWithState).registerState(
          (this as BlocControllerWithState).initialState,
        );
      }
    }
  }

  final Key widgetKey;
  final PublishSubject<BlocController> _subject;

  StreamSink<BlocController> get sink => _subject.sink;
  Observable<BlocController> get stream => _subject.stream;

  StreamSubscription subscribeToUpdates(void Function (BlocController) onUpdate, { void Function(Error, StackTrace) onError, void Function() onDone }) {
    return _subject.listen(onUpdate, onError: onError, onDone: onDone);
  }

  Future<void> publishUpdate() async {
    if (_subject.isClosed) return;

    try {
      preUpdatePublished();
      _subject.add(this);
      postUpdatePublished();
    } catch (e, st) {
      onError(e, st);
    }
  }

  @mustCallSuper
  void dispose() {
    _subject.close();
  }

  @protected
  Stream<BlocController> transform(Stream<BlocController> input) => input;
  @protected
  void onError(Object error, StackTrace stackTrace) => print(error);
  @protected
  void preUpdatePublished() => null;
  @protected
  void postUpdatePublished() => null;

}

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