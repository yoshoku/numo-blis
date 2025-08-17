# frozen_string_literal: true

require 'etc'
require 'numo/linalg/linalg'

require_relative 'blis/version'
require_relative 'blis/blisext'

module Numo
  # @!visibility private
  module Linalg
    # @!visibility private
    module Loader
      module_function

      # @!visibility private
      def load_blis(*dirs, exc: true) # rubocop:disable Naming/PredicateMethod
        dirs.each do |d|
          f_blis = dlopen(Blas, 'libblis', d)
          f_lapacke = dlopen(Lapack, 'liblapacke', d)
          @@libs = [f_blis, f_lapacke].compact # rubocop:disable Style/ClassVars
          return true
        rescue StandardError
          # Suppress errors as well as loading methods in Numo::Linalg::Loader.
        end
        raise 'Failed to find BLIS/LAPACK library' if exc

        false
      end
    end
  end
end

ENV['BLIS_NUM_THREADS'] ||= Etc.nprocessors.to_s

Numo::Linalg::Loader.load_blis(File.expand_path("#{__dir__}/../../vendor/lib/"))
