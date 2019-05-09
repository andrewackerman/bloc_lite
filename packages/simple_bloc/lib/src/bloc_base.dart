import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase<V> {

  BlocBase(V initialValue)
    : _subject = BehaviorSubject<V>.seeded(initialValue);
  
  final BehaviorSubject<V> _subject;

  Observable get stream => _subject.stream;
  V get currentValue => _subject.stream.value;

  StreamSubscription<V> subscribeToUpdates(void Function (V) onData, { void Function(Error, StackTrace) onError, void Function() onDone }) {
    return _subject.listen(onData, onError: onError, onDone: onDone);
  }

  @mustCallSuper
  void dispose() {
    _subject.close();
  }

  @protected
  void publishValue(V value) {
    if (_subject.isClosed) return;

    try {
      V oldValue = currentValue;
      V newValue = value;

      if (oldValue == newValue) return;

      _subject.add(newValue);

      onValueChanged(oldValue, newValue);
    } catch (e, st) {
      onError(e, st);
    }
  }

  @protected
  Stream<V> transform(Stream<V> input) {
    return input;
  }

  @protected
  void onError(Object error, StackTrace stackTrace) => print(error);
  @protected
  void onValueChanged(V oldValue, V newValue) => null;

}