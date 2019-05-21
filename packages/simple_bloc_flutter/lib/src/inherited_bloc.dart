import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

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