## [0.5.2] - 2025-04-28

- Change the version of BLIS to be downloaded to 1.1.
- Change to use automatic detection of CPU type on macOS.

## [0.5.1] - 2025-01-03

- Fix BLIS_VERSION and LAPACK_VERSION constants.

## [0.5.0] - 2025-01-03

- Change the version of BLIS to be downloaded to 1.0.
- Change the version of LAPCK to be downloaded to 3.11.0.

## [0.4.1] - 2022-07-31

- Refactor codes and configs with RuboCop.

## [0.4.0] - 2022-04-15

- Change the version of BLIS to be downloaded to 0.9.0.

## [0.3.0] - 2022-01-30

- Changed to use generic CPU type when installing on Apple M1 mac.
- Fixed a typo on threading method detection process.
- Introduced conventional commits.

## [0.2.0] - 2021-07-31

- Added enable-threading option to specify the threding method of BLIS.

  ```
  $ gem install numo-blis -- --enable-threading=openmp
  ```

- Changed to detect threading method automatically when the enable-threading option is not given.

## [0.1.0] - 2021-07-17

- Initial release
