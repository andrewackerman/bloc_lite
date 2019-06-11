[![pub package](https://img.shields.io/pub/v/bloc_lite.svg)](https://pub.dartlang.org/packages/bloc_lite)

A library aimed at making it simple to use the BLoC design pattern to separate the presentation code from the business logic and the state. While this library aims to make it possible to make a project 100% compliant with the BLoC pattern, it also recognizes that 100% compliance is not always advisable or necessary so it also facilitates ease-of-use compromises that enable simple integration with projects of any scope.

This is a general-purpose BLoC library. For platform-specific applications, see [bloc_lite_flutter](https://pub.dev/packages/bloc_lite_flutter).

## API Reference

 - [Dart Docs](https://pub.dev/documentation/bloc_lite/latest/bloc_lite/bloc_lite-library.html)

## BLoC Overview

BLoC is a development pattern designed and pioneered by Google, and it stands for **B**usiness **Lo**gic **C**omponent. (For a thorough explanation, see [this article by Didier Boelens](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/) or [this video by Google at DartConf 2018](https://www.youtube.com/watch?v=PLHln7wHgPE)) 

What BLoC is and does:

 - Separates Presentation Layer code from Business Logic code.
 - Exclusively uses [Streams](https://dart.dev/tutorials/language/streams) for communication to and from a BLoC object.
 - Enables reactive and testable programming and app development.
 - Is platform and environment-agnostic.

What BLoC is not and does not:

 - Make assumptions on how the Business Logic is structured or organized within a BLoC object.
 - Impose opinionated restrictions on how communication to and from BLoC objects are structured.
 - Impose opinionated restrictions on how the state is represented or managed.
 - Is not a drop-in state-management solution.

Complete adherance to the BLoC pattern is not always desirable for every project. Depending on the scope and complexity of your project, you may consider a hybrid solution that incorporates only the parts of BLoC or consider if simple Dependency Injection is enough for your needs.

## Glossary

 - **BLoC** is the design pattern that this library is based on. (See BLoC Overview section above)
 - A **bloc** is a single BLoC object instance. They are self-sufficient containers of code that can be passed around like any other object.
 - **BlocController** is a bloc that is responsible for managing business logic. Update callbacks can be registered with the bloc to be notified of any changes; alternatively, it also exposes the *sink* and *stream* properties for finer control over the input and output, respectively. It is the base implementation of BLoC in this library.
 - **Stream** is a programming construct that takes data from one or more sources and pushes it to one or more destinations. It is commonly treated as a watcher that notifies any listeners when new data has been made available.
 - A **controller** is an object that is responsible for executing code relevant to a particular purpose. For example, in a GUI application, the controller can be the business logic portion of code that is tailored for use to a particular widget.
 - A **state** is an object that maintains a fixed representation of data that other code can reference. The state can be *mutable*, meaning the data within can be freely modified (or "mutated"), or *immutable*, meaning the data cannot be modified.

## Usage

For a simple counter bloc, we can create a `BlocController` class like so:

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

The bloc is capable of maintaining its own state. In the `increment` and `decrement` functions, the bloc updates its state accordingly, then notifies listeners that changes have been made by calling `publishUpdate`.

The bloc can now be used elsewhere in the project:

```dart
void main() {
    final counterBloc = CounterBloc();

    counterBloc.increment();
    counterBloc.increment();
    counterBloc.decrement();

    print(counterBloc.value);

    counterBloc.dispose();
}

// Output: 
// 1
```

(Note the call to `dispose`. This is important as the controller must be disposed in order to close the underlying stream and free up its resources.)

To listen to changes in the bloc, you can simply register a callback:

```dart
void main() {
    final counterBloc = CounterBloc();
    counterBloc.listen(blocUpdated);

    counterBloc.increment();
    counterBloc.increment();
    counterBloc.decrement();

    counterBloc.dispose();
}

void blocUpdated(CounterBloc bloc) {
    print(bloc.value);
}

// Output:
// 1
// 2
// 1
```

## Todo

 - Add examples of synchronizing a *BlocState* with a data store
 - Add examples of advanced sink/stream usage
 - Add support for immutable state
 - Add testing suite
 - Add CodeMagic integration for automated testing and deployment