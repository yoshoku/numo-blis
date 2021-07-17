# frozen_string_literal: true

require_relative 'lib/numo/blis/version'

Gem::Specification.new do |spec|
  spec.name          = 'numo-blis'
  spec.version       = Numo::BLIS::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = <<~MSG
    Numo::BLIS downloads and builds BLIS during installation and
    uses that as a background library for Numo::Linalg.
  MSG
  spec.description = <<~MSG
    Numo::BLIS downloads and builds BLIS during installation and
    uses that as a background library for Numo::Linalg.
  MSG
  spec.homepage      = 'https://github.com/yoshoku/numo-blis'
  spec.license       = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/yoshoku/numo-blis/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
