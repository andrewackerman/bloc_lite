import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'bloc_base.dart';

abstract class Bloc<V> extends BlocBase<V> {

  Bloc(V initialState)
    : super(initialState);

  @mustCallSuper
  void dispose() {
    super.dispose();
  }

}

abstract class EventBloc<E, V> extends BlocBase<V> {

  EventBloc(V initialState)
    : _eventSubject = PublishSubject<E>(),
      super(initialState);

  final PublishSubject<E> _eventSubject;

  Observable get eventStream => _eventSubject.stream;

  StreamSubscription<E> subscribeToEvents(void Function (E) onEvent, { void Function(Error, StackTrace) onError, void Function() onDone }) {
    return _eventSubject.listen(onEvent, onError: onError, onDone: onDone);
  }

  @protected
  Stream<V> handleEvent(E event, dynamic payload);

  void dispatch(E event, dynamic payload) async {
    await for (final update in handleEvent(event, payload)) {
      publishValue(update);
    }

    publishEvent(event);
  }

  @protected
  void publishEvent(E event) {
    if (_eventSubject.isClosed) return;

    _eventSubject.add(event);
    onEvent(event);
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    super.dispose();
  }

  @protected
  void onEvent(E event) => null;

}