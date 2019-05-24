## [0.1.1]

* Added a `publishMutation` method to `BlocState` to enable implementing classes to manually trigger a mutation event.
* Changed `mutate` in `BlocState` to call `publishMutation` after executing the closure function.

## [0.1.0]

* Initial release.
