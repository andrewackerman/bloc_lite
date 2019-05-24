## [0.1.3]

* Minor update to README

## [0.1.2]

* Changed `subscribeToUpdates` in `BlocController` to `listen` for compactness and to more closely reflect naming conventions in other libraries.
* Changed `subscribeToMutations` in `BlocState` to `listen` for compactness and to more closely reflect naming conventions in other libraries.
* Added a more complete README

## [0.1.1]

* Added a `publishMutation` method to `BlocState` to enable implementing classes to manually trigger a mutation event.
* Changed `mutate` in `BlocState` to call `publishMutation` after executing the closure function.

## [0.1.0]

* Initial release.
