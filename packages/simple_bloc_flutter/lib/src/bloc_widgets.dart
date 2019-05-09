import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

Type _typeOf<T>() => T;

class InheritedBloc<B extends BlocBase> extends StatefulWidget {

  InheritedBloc({
    Key key,
    @required this.child,
    @required this.bloc,
  })
    : assert(child != null),
      assert(bloc != null),
      super(key: key);

  final Widget child;
  final B bloc;

  @override
  _InheritedBlocState<B> createState() => _InheritedBlocState<B>();

  static B of<B extends BlocBase>(BuildContext context) {
    final type = _typeOf<_InheritedBlocWidget<B>>();
    return getBlocOfType(context, type) as B;
  }

  static Bloc getBlocOfType(BuildContext context, Type type) {
    _InheritedBlocWidget provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }

}

class _InheritedBlocState<B extends BlocBase> extends State<InheritedBloc> {

  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return _InheritedBlocWidget(
      bloc: widget.bloc,
      child: widget.child,
    );
  }

}

class InheritedBlocTree extends StatelessWidget {

  InheritedBlocTree({
    Key key,
    @required this.child,
    @required this.blocs,
  }) 
    : assert(child != null),
      assert(blocs != null),
      super(key: key);

  final Widget child;
  final List<BlocBase> blocs;

  @override
  Widget build(BuildContext cxt) {
    Widget child = this.child;

    for (var bloc in blocs) {
      child = _InheritedBlocWidget(
        bloc: bloc,
        child: child,
      );
    }

    return child;
  }

}

class _InheritedBlocWidget<B extends BlocBase> extends InheritedWidget {

  _InheritedBlocWidget({
    Key key,
    @required Widget child,
    @required this.bloc,
  }): super(key: key, child: child);

  final B bloc;

  @override
  bool updateShouldNotify(_InheritedBlocWidget oldWidget) => false;

}

class BlocBuilder<V> extends StatefulWidget {

  BlocBuilder({
    Key key,
    @required this.bloc,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  }) : assert(bloc != null),
       assert(builder != null),
       super(key: key);

  BlocBuilder.inherited({
    Key key,
    @required BuildContext context,
    @required Widget Function(BuildContext, V) builder,
    Function(BuildContext, Error, StackTrace) builderOnError,
    Widget Function(BuildContext) builderOnClose,
  }) : this(
      key: key,
      bloc: InheritedBloc.of<Bloc<V>>(context),
      builder: builder,
      builderOnError: builderOnError,
      builderOnClose: builderOnClose,
    );

  final Bloc<V> bloc;
  final Widget Function(BuildContext, V) builder;
  final Widget Function(BuildContext, Error, StackTrace) builderOnError;
  final Widget Function(BuildContext) builderOnClose;

  @override
  _BlocBuilderState<V> createState() => _BlocBuilderState<V>();

}

class _BlocBuilderState<V> extends State<BlocBuilder<V>> {

  StreamSubscription _subscription;
  _BlocBuilderBlocState _builderState;
  V _value;
  Object _error;
  StackTrace _stackTrace;

  @override
  void initState() {
    _subscribe();
    _value = widget.bloc.currentValue;

    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(BlocBuilder<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc.currentValue != widget.bloc.currentValue) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  void _onData(V value) {
    setState(() {
      _value = value;
      _builderState = _BlocBuilderBlocState.normal;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    print('[WARNING] Subscribed bloc stream threw an error.');
    print(stackTrace);

    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _value = null;
      _builderState = _BlocBuilderBlocState.error;
    });
  }

  void _onDone() {
    setState(() {
      _value = null;
      _builderState = _BlocBuilderBlocState.done;
    });
  }

  void _subscribe() {
    _subscription = widget.bloc.subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == _BlocBuilderBlocState.done && widget.builderOnClose != null) {
      return widget.builderOnClose(cxt);
    }

    if (_builderState == _BlocBuilderBlocState.error && widget.builderOnError != null) {
      return widget.builderOnError(cxt, _error, _stackTrace);
    }
    
    return widget.builder(cxt, _value);
  }

}

class EventBlocBuilder<E, V> extends StatefulWidget {

  EventBlocBuilder({
    Key key,
    @required this.bloc,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  }) : assert(bloc != null),
       assert(builder != null),
       super(key: key);
  
  EventBlocBuilder.inherited({
    Key key,
    @required BuildContext context,
    @required Widget Function(BuildContext, E, V) builder,
    Function(BuildContext, Error, StackTrace) builderOnError,
    Widget Function(BuildContext) builderOnClose,
  }) : this(
      key: key,
      bloc: InheritedBloc.of<EventBloc<E, V>>(context),
      builder: builder,
      builderOnError: builderOnError,
      builderOnClose: builderOnClose,
    );

  final EventBloc<E, V> bloc;
  final Widget Function(BuildContext, E, V) builder;
  final Widget Function(BuildContext, Error, StackTrace) builderOnError;
  final Widget Function(BuildContext) builderOnClose;

  @override
  _EventBlocBuilderState<E, V> createState() => _EventBlocBuilderState<E, V>();

}

class _EventBlocBuilderState<E, V> extends State<EventBlocBuilder<E, V>> {

  StreamSubscription _subscription;
  StreamSubscription _eventSubscription;

  _BlocBuilderBlocState _builderState;
  E _event;
  V _value;
  Object _error;
  StackTrace _stackTrace;

  @override
  void initState() {
    _subscribe();
    super.initState();
  }

  @override
  void didUpdateWidget(EventBlocBuilder<E, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc.currentValue != widget.bloc.currentValue) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

    void _onData(V value) {
    setState(() {
      _value = value;
      _builderState = _BlocBuilderBlocState.normal;
    });
  }

  void _onEvent(E event) {
    setState(() {
      _event = event;
      _builderState = _BlocBuilderBlocState.normal;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    print('[WARNING] Subscribed bloc stream threw an error.');
    print(stackTrace);

    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _event = null;
      _value = null;
      _builderState = _BlocBuilderBlocState.error;
    });
  }

  void _onDone() {
    setState(() {
      _event = null;
      _value = null;
      _builderState = _BlocBuilderBlocState.done;
    });
  }

  void _subscribe() {
    _subscription = widget.bloc.subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
    _eventSubscription = widget.bloc.subscribeToEvents(_onEvent, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
    if (_eventSubscription != null) {
      _eventSubscription.cancel();
      _eventSubscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == _BlocBuilderBlocState.done && widget.builderOnClose != null) {
      return widget.builderOnClose(cxt);
    }

    if (_builderState == _BlocBuilderBlocState.error && widget.builderOnError != null) {
      return widget.builderOnError(cxt, _error, _stackTrace);
    }
    
    return widget.builder(cxt, _event, _value);
  }

}

enum _BlocBuilderBlocState {
  normal,
  error,
  done,
}