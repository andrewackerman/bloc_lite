import 'package:meta/meta.dart';

import 'bloc_controller.dart';
import 'bloc_state.dart';

/// An interface that equips a `BlocController` with a built-in state.
/// This state must be a class that inherits from `BlocState`.
abstract class BlocControllerWithState<S extends BlocState> {

  S _state;
  S get state => _state;

  /// If an implementing class overrides this getter, the controller will
  /// be initialized with the returned object as the initial state.
  @required
  S get initialState;

  /// Sets the underlying state object and registers this object's state
  /// listeners to be notified of updates to the state's stream.
  void registerState(S state) {
    if (identical(_state, state)) return;
    if (_state != null) _state.dispose();

    _state = state;
    _state.controller = this as BlocController;

    _state.subscribeToMutations(onStateMutate, onError: onStateError, onDone: onStateDone);
  }
  
  /// Method that is called when the state object signals a mutation. Notifies this 
  /// controller's stream of the change.
  @protected
  @mustCallSuper
  void onStateMutate(S data) {
    (this as BlocController).publishUpdate();
  }

  /// Method that is called when the state's stream reports an error. Prints the error message by default.
  @protected
  void onStateError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  }

  /// Method that is called when the state's stream closes. Does nothing by default.
  @protected
  void onStateDone() => null;
}
