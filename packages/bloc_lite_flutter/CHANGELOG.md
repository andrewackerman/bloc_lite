## [0.2.0]

* Removed [BlocStateWidget] in correspondence with the removal of [BlocState] from the core library. (See that changelog for reasoning.)
* Renamed [BlocWidget] to [BlocBuilder] for clarity on the purpose of the widget.
* Added `autoDispose` field to [BlocBuilder] and [InheritedBloc] that, if true, facilitates the disposal of `controller` when the widgets themselves are disposed. (True by default, false by default on [BlocBuilder.inherited].)
* [InheritedBloc] now extends [StatefulWidget] in order to support automatic bloc disposal. (An internal class that extends [InheritedWidget] has been added to maintain compatibility with Flutter-standard dependency injection procedures and to keep the performance of [InheritedBloc.of] unchanged.)
* Added [BlocWidget] as an abstract class that extends [StatefulWidget]. The purpose of the class is to enable conciseness in associating a bloc controller with a user-defined widget that extends [BlocWidget].

## [0.1.1]

* Updated bloc_lite dependency to 0.1.2
* Added a more complete README

## [0.1.0]

* Initial release.
