import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_controller_with_state.dart';

abstract class BlocController {

  BlocController() : this.withState(null);
  BlocController.withState([BlocState state])
      : _subject = PublishSubject() {
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