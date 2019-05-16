import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

typedef BlocBuilder<B extends BlocController> = Widget Function(BuildContext context, B controller);
typedef BlocStateBuilder<B extends BlocController, S extends BlocState> = Widget Function(BuildContext context, B controller, S state);
typedef BlocBuilderOnError = Widget Function(BuildContext context, Object error, StackTrace stackTrace);
typedef BlocBuilderOnClose = Widget Function(BuildContext context);

Type _typeOf<T>() => T;

class InheritedBloc<B extends BlocController> extends InheritedWidget {

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

  static B of<B extends BlocController>(BuildContext context) {
    final type = _typeOf<InheritedBloc<B>>();
    final provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget as InheritedBloc<B>;
    return provider?.bloc;
  }

  InheritedBloc<B> withChild(Widget child) {
    return InheritedBloc(key: this.key, bloc: this.bloc, child: child);
  }

  @override
  bool updateShouldNotify(InheritedBloc oldWidget) => false;

}

class InheritedBlocTree extends StatelessWidget {

  InheritedBlocTree({
    Key key,
    @required this.child,
    @required this.blocProviders,
  }) 
    : assert(child != null),
      assert(blocProviders != null),
      super(key: key);

  final Widget child;
  final List<InheritedBloc> blocProviders;

  @override
  Widget build(BuildContext cxt) {
    Widget child = this.child;

    for (var bloc in blocProviders) {
      child = bloc.withChild(child);
    }

    return child;
  }

}

class BlocWidget<B extends BlocController> extends StatefulWidget {

  BlocWidget({
    Key key,
    @required this.controller,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  }) : assert(controller != null),
       assert(builder != null),
       super(key: key);

  factory BlocWidget.inherited({
    Key key,
    @required BuildContext context,
    @required Widget Function(BuildContext, B) builder,
    Widget Function(BuildContext, Error, StackTrace) builderOnError,
    Widget Function(BuildContext) builderOnClose,
  }) {
    final controller = InheritedBloc.of<B>(context);
    assert(controller != null);

    return BlocWidget(
      key: key,
      controller: controller,
      builder: builder,
      builderOnError: builderOnError,
      builderOnClose: builderOnClose,
    );
  }

  final B controller;
  final BlocBuilder<B> builder;
  final BlocBuilderOnError builderOnError;
  final BlocBuilderOnClose builderOnClose;

  @override
  _BlocWidgetState<B> createState() => _BlocWidgetState<B>();

}

class _BlocWidgetState<B extends BlocController> extends State<BlocWidget<B>> {

  StreamSubscription _subscription;
  _BlocWidgetBlocState _builderState;
  Object _error;
  StackTrace _stackTrace;

  @override
  void initState() {
    _subscribe();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(BlocWidget<B> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (_subscription != null) {
      _unsubscribe();
    }
    _subscribe();
  }

  void _onData(B value) {
    setState(() {
      _builderState = _BlocWidgetBlocState.normal;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    print('[WARNING] Subscribed bloc stream threw an error.');
    print(stackTrace);

    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _builderState = _BlocWidgetBlocState.error;
    });
  }

  void _onDone() {
    setState(() {
      _builderState = _BlocWidgetBlocState.done;
    });
  }

  void _subscribe() {
    _subscription = widget.controller.subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == _BlocWidgetBlocState.done && widget.builderOnClose != null) {
      return widget.builderOnClose(cxt);
    }

    if (_builderState == _BlocWidgetBlocState.error && widget.builderOnError != null) {
      return widget.builderOnError(cxt, _error, _stackTrace);
    }
    
    print('building bloc widget');
    print(widget.builder);
    print(widget.controller);
    return widget.builder(cxt, widget.controller);
  }

}

class BlocStateWidget<B extends BlocController, S extends BlocState> extends StatefulWidget {

  BlocStateWidget({
    Key key,
    @required this.controller,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  }) : assert(controller != null),
       assert(controller is BlocControllerWithState),
       assert(builder != null),
       super(key: key) {
    print(builder.runtimeType);
  }

  BlocStateWidget.inherited({
    Key key,
    @required BuildContext context,
    @required Widget Function(BuildContext, B, S) builder,
    Function(BuildContext, Error, StackTrace) builderOnError,
    Widget Function(BuildContext) builderOnClose,
  }) : this(
      key: key,
      controller: InheritedBloc.of<B>(context),
      builder: builder,
      builderOnError: builderOnError,
      builderOnClose: builderOnClose,
    );

  final B controller;
  final BlocStateBuilder<B, S> builder;
  final BlocBuilderOnError builderOnError;
  final BlocBuilderOnClose builderOnClose;

  @override
  _BlocStateWidgetState<B, S> createState() => _BlocStateWidgetState<B, S>();

}

class _BlocStateWidgetState<B extends BlocController, S extends BlocState> extends State<BlocStateWidget<B, S>> {

  StreamSubscription _subscription;
  _BlocWidgetBlocState _builderState;
  Object _error;
  StackTrace _stackTrace;

  @override
  void initState() {
    _subscribe();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(BlocStateWidget<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (_subscription != null) {
      _unsubscribe();
    }
    _subscribe();
  }

  void _onData(B value) {
    setState(() {
      _builderState = _BlocWidgetBlocState.normal;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    print('[WARNING] Subscribed bloc stream threw an error.');
    print(stackTrace);

    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _builderState = _BlocWidgetBlocState.error;
    });
  }

  void _onDone() {
    setState(() {
      _builderState = _BlocWidgetBlocState.done;
    });
  }

  void _subscribe() {
    _subscription = widget.controller.subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == _BlocWidgetBlocState.done && widget.builderOnClose != null) {
      return widget.builderOnClose(cxt);
    }

    if (_builderState == _BlocWidgetBlocState.error && widget.builderOnError != null) {
      return widget.builderOnError(cxt, _error, _stackTrace);
    }

    final state = (widget.controller as BlocControllerWithState).state;
    return widget.builder(cxt, widget.controller, state);
  }

}

enum _BlocWidgetBlocState {
  normal,
  error,
  done,
}
