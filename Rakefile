# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rake/extensiontask'

task build: :compile

Rake::ExtensionTask.new('blisext') do |ext|
  ext.ext_dir = 'ext/numo/blis'
  ext.lib_dir = 'lib/numo/blis'
end

task default: %i[clobber compile spec]
