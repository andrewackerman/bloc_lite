import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_controller_with_state.dart';
import 'bloc_state.dart';

/// Provides a BLoC view controller interface to a class. Provides a `PublishSubject`
/// stream that can be subscribed to for updates. Also exposes a `StreamSink` and 
/// a `Observable` for more control over the output. Updates are typically triggered 
/// by calling the `publishUpdate` method.
abstract class BlocController {

  BlocController() : this.withState(null);

  /// Initializes the controller with an optional state. If the inheriting class 
  /// does not implement [BlocControllerWithState], the `state` parameter is ignored.
  BlocController.withState([BlocState state])
      : _subject = PublishSubject() {
    if (this is BlocControllerWithState) {
      final asState = this as BlocControllerWithState;
      if (state != null) {
        asState.registerState(state);
      } else if (asState.initialState != null) {
        asState.registerState(asState.initialState);
      } else {
        throw StateError(
          'A class that implements `BlocControllerWithState` must have ' +
          'an initial state either by providing the `withState` constructor ' +
          'with a state object or by overriding the `initialState` ' +
          'getter property.'
        );
      }
    }
  }

  final PublishSubject<BlocController> _subject;

  StreamSink<BlocController> get sink => _subject.sink;
  Observable<BlocController> get stream => _subject.stream;

  /// Registers the given callback methods with the underlying stream and returns 
  /// the resulting `StreamSubscription`.
  StreamSubscription subscribeToUpdates(void Function (BlocController) onUpdate, { void Function(Error, StackTrace) onError, void Function() onDone }) {
    return _subject.listen(onUpdate, onError: onError, onDone: onDone);
  }

  /// Notifies the underlying stream of an update. Passes a reference to this object to the stream.
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

  /// Closes the underlying stream. Inheriting classes that overload this method must call `super.dispose()`.
  @mustCallSuper
  void dispose() {
    _subject.close();
  }

  /// Method that is called when the stream reports an error. Prints the error message by default.
  @protected
  void onError(Object error, StackTrace stackTrace) => print(error);

  /// Method that is called when [publishUpdate] is called but before the stream is notified. Does nothing by default.
  @protected
  void preUpdatePublished() => null;

  /// Method that is called when [publishUpdate] is called, after the stream is notified. Does nothing by default.
  @protected
  void postUpdatePublished() => null;

}