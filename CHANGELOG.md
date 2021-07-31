## [Unreleased]

## [0.2.0] - 2021-07-31

- Added enable-threading option to specify the threding method of BLIS.

  ```
  $ gem install numo-blis -- --enable-threading=openmp
  ```

- Changed to detect threading method automatically when the enable-threading option is not given.

## [0.1.0] - 2021-07-17

- Initial release
