import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

Type _typeOf<T>() => T;

class InheritedBloc<B extends BlocController> extends InheritedWidget {

  InheritedBloc({
    Key key,
    this.child,
    @required this.bloc,
  })
    : assert(bloc != null),
      super(key: key);

  final Widget child;
  final B bloc;

  static B of<B extends BlocController>(BuildContext context) {
    final type = _typeOf<InheritedBloc<B>>();
    final provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget as InheritedBloc<B>;
    return provider?.bloc;
  }

  static Iterable all(BuildContext context) sync* {
    final blocs = <BlocController>[];
    context.visitAncestorElements((elem) {
      if (elem.widget is InheritedBloc) {
        blocs.add((elem.widget as InheritedBloc).bloc);
      }
      return true;
    });

    yield* blocs;
  }

  static Iterable allOfType<B extends BlocController>(BuildContext context) sync* {
    final blocs = <B>[];
    context.visitAncestorElements((elem) {
      if (elem.widget is InheritedBloc<B>) {
        blocs.add((elem.widget as InheritedBloc<B>).bloc);
      }
      return true;
    });

    yield* blocs;
  }

  InheritedBloc<B> withChild(Widget child) {
    return InheritedBloc<B>(key: this.key, bloc: this.bloc, child: child);
  }

  @override
  bool updateShouldNotify(InheritedBloc oldWidget) => false;

}