[![pub package](https://img.shields.io/pub/v/bloc_lite.svg)](https://pub.dartlang.org/packages/bloc_lite)

A Flutter library aimed at making it simple to use the BLoC design pattern to separate the presentation code from the business logic and the state.

This library is built to be used in conjunction with [bloc_lite](https://pub.dev/packages/bloc_lite).

## API Reference

 - [Dart Docs](https://pub.dev/documentation/bloc_lite_flutter/latest/bloc_lite_flutter/bloc_lite_flutter-library.html)

## Examples

 - [Simple Counter app](https://github.com/andrewackerman/bloc_lite/tree/master/examples/simple_flutter_counter)
 - [Counter App using state](https://github.com/andrewackerman/bloc_lite/tree/master/examples/simple_flutter_counter_with_state)
 - [Counter App using dependency injection](https://github.com/andrewackerman/bloc_lite/tree/master/examples/simple_flutter_counter_with_inheritence)
 - [Counter App using multiple blocs and `InheritedBlocTree`](https://github.com/andrewackerman/bloc_lite/tree/master/examples/simple_flutter_with_tree)
 - [Todo](https://github.com/andrewackerman/bloc_lite/tree/master/examples/todo)

## Glossary

 - An **InheritedBloc** is an inherited widget that uses dependency injection to insert a bloc into the widget tree. This bloc can then later be retrieved by calling `InheritedBloc.of<BlocTypeHere>(context)` on any widget that is a descendent of this widget.
 - An **InheritedBlocTree** is a widget that allows a convenient way to insert multiple *InheritedBloc*s into the widget tree without bloating the UI code.
 - A **BlocWidget** is a widget that registers a bloc and reactively rebuilds its widget tree whenever that bloc triggers an update. This is the primary way to use blocs in Flutter using this library.
 - A **BlocStateWidget** is an extension of the *BlocWidget* that is specially designed to work with blocs that extend from *BlocStateController*.

## Usage

We can use the counter example from the [bloc_lite docs](https://github.com/andrewackerman/bloc_lite/blob/master/packages/bloc_lite/README.md) to build a simple counter app in Flutter. (See above for a complete working example of a counter app using several methodologies.)

```dart
class CounterBloc extends BlocController {
    int value = 0;

    void increment() {
        value += 1;
        publishUpdate();
    }

    void decrement() {
        value -= 1;
        publishUpdate();
    }
}
```

To use this bloc in a widget, you can simply create the controller in your widget class and pass it to a `BlocWidget`:

```dart
class CounterWidget extends StatefulWidget {
    @override
    CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
    final controller = CounterBloc();

    @override
    dispose() {
        controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return BlocWidget(
            controller: controller,
            builder: (BuildContext context, CounterBloc bloc)
                => Center(
                    child: Text(bloc.value.toString()),
                ),
        );
    }
}
```

Whenever `controller` publishes an update (for example, by elsewhere in the app calling the `increment` or `decrement` function), the `BlocWidget` will automatically refresh its widget tree. (Note that the widget class extends `StatefulWidget` and within the state the `dispose` method is overriden to call `controller.dispose()`. This is important as the controller must be disposed in order to close the underlying stream and free up its resources.)

When using a controller that extends `BlocStateController`, you can use a specialized widget called `BlocStateWidget`:

```dart
class CounterState extends BlocState {
    int value = 0;
}

class CounterBloc extends BlocStateController<CounterState> {
    @override
    CounterState get initialState => CounterState();

    void increment() {
        state.mutate(() {
            state.value += 1;
        });
    }

    void decrement() {
        state.mutate(() {
            state.value -= 1;
        });
    }
}
```

```dart
class CounterWidget extends StatefulWidget {
    @override
    CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
    final controller = CounterBloc();

    @override
    dispose() {
        controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return BlocStateWidget(
            controller: controller,
            builder: (BuildContext context, CounterBloc bloc, CounterState state)
                => Center(
                    child: Text(state.toString()),
                ),
        );
    }
}
```

The `BlocStateWidget` behaves identically to `BlocWidget`, except it also refreshes whenever the state associated with the controller is mutated. It also passes a reference to the state in the builder function for easy use.

Declaring the bloc in the same class as the widget that uses it is fine for widgets that utilize a local controller and state, but for global controllers and states, you need to be able to access a bloc further down the widget tree from where it was created. This is where `InheritedBloc` comes in:

```dart
class ParentWidget extends StatefulWidget {
    @override
    ParentWidgetState createState() => ParentWidgetState();
}

class ParentWidgetState extends State<ParentWidget> {
    final controller = CounterBloc();

    @override
    dispose() {
        controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return InheritedBloc(
            bloc: controller,
            child: ChildWidget(),
        );
    }
}

class ChildWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final controller = InheritedBloc.of<CounterBloc>(context);
        return BlocWidget(
            controller: controller,
            builder: (BuildContext context, CounterBloc bloc)
                => Center(
                    child: Text(bloc.value.toString()),
                ),
        );
    }
}
```

(Note that, although the parent widget extends `StatefulWidget` in order to properly dispose of the controller, the child widget does not need to and can safely extend `StatelessWidget`.)

In the previous example, `ChildWidget` uses `InheritedBloc.of` to get a reference to the inherited bloc. When the bloc is going to be used as the controller of a `BlocWidget`, this is not necessary, as those classes expose a convenient `inherited<BlocType>` factory constructor for that purpose:

```dart
class ChildWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return BlocWidget<CounterBloc>.inherited(
            context: context,
            builder: (BuildContext context, CounterBloc bloc)
                => Center(
                    child: Text(bloc.value.toString()),
                ),
        );
    }
}
```

In that example, the inherited bloc is automatically inferred from the corresponding `InheritedBloc`, eliminating the need to explicitly obtain it. (`BlocStateWidget` offers the same convenient factory constructor, but requires the two type parameters `inherited<BlocType, BlocStateType>`.)

Sometimes you may find yourself injecting multiple blocs at once into the widget tree. To do this, you can nest multiple `InheritedBloc`s, but that can quickly bloat the widget tree:

```dart
Widget build(BuildContext context) {
    return InheritedBloc(
        bloc: controllerA,
        child: InheritedBloc(
            bloc: controllerB,
            child: InheritedBloc(
                bloc: controllerC,
                child: InheritedBloc(
                    ...
                ),
            ),
        ),
    );
}
```

Instead, you can use an `InheritedBlocTree` to insert many blocs into the tree at once in an organized and concise fashion:

```dart
Widget build(BuildContext context) {
    return InheritedBlocTree(
        blocs: [
            InheritedBloc(bloc: controllerA),
            InheritedBloc(bloc: controllerB),
            InheritedBloc(bloc: controllerC),
            ...
        ],
        child: ...
    )
}
```

Any blocs injected into the tree in this manner can be retrieved using the same `InheritedBloc.of` approach as before.

## Todo

 - Add testing suite
 - CodeMagic integration for automated testing and deployment