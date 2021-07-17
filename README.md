# Numo::BLIS

[![Build Status](https://github.com/yoshoku/numo-blis/actions/workflows/build.yml/badge.svg)](https://github.com/yoshoku/numo-blis/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/numo-blis.svg)](https://badge.fury.io/rb/numo-blis)
[![BSD 3-Clause License](https://img.shields.io/badge/License-BSD%203--Clause-orange.svg)](https://github.com/yoshoku/numo-blis/blob/main/LICENSE.txt)

Numo::BLIS downloads and builds [BLIS](https://github.com/flame/blis) during installation and
uses that as a background library for [Numo::Linalg](https://github.com/ruby-numo/numo-linalg).

## Installation

Building LAPACK with BLIS requires cmake and Fortran compiler.

macOS:

    $ brew install gcc gfortran cmake

Ubuntu:

    $ sudo apt-get install gcc gfortran cmake

Add this line to your application's Gemfile:

```ruby
gem 'numo-blis'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install numo-blis

## Usage

Numo::BLIS loads Numo::NArray and Numo::Linalg using BLIS as a background library.
You can use Numo::NArray and Numo::Linalg just by loading Numo::BLIS.

```ruby
require 'numo/blis'

x = Numo::DFloat.new(5, 2).rand
c = x.transpose.dot(x)
eig_val, eig_vec = Numo::Linalg.eigh(c)
```

Moreover, the versions of background libraries are defined by constants.

```ruby
> Numo::BLIS::BLIS_VERSION
=> "0.8.1"
> Numo::BLIS::LAPACK_VERSION
=> "3.10.0"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/numo-blis.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [code of conduct](https://github.com/yoshoku/numo-blis/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause)
