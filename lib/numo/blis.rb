# frozen_string_literal: true

require 'numo/linalg/linalg'

require_relative 'blis/version'
require_relative 'blis/blisext'

module Numo
  module Linalg
    module Loader
      module_function

      def load_blis(*dirs, exc: true)
        dirs.each do |d|
          begin
            f_blis = dlopen(Blas, 'libblis', d)
            f_lapacke = dlopen(Lapack, 'liblapacke', d)
            @@libs = [f_blis, f_lapacke].compact
            return true
          rescue
          end
        end
        raise 'Failed to find BLIS/LAPACK library' if exc
        false
      end
    end
  end
end

Numo::Linalg::Loader.load_blis(File.expand_path("#{__dir__}/../../vendor/lib/"))
