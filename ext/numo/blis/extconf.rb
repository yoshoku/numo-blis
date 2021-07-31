
require 'etc'
require 'fileutils'
require 'mkmf'
require 'open-uri'
require 'open3'
require 'rbconfig'
require 'rubygems/package'

ENABLE_THREADING_ARG = arg_config('--enable-threading')

VENDOR_DIR = File.expand_path("#{__dir__}/../../../vendor")
SOEXT = RbConfig::CONFIG['SOEXT'] || case RUBY_PLATFORM
                                     when /mswin|msys|mingw|cygwin/
                                       'dll'
                                     when /darwin|mac os/
                                       'dylib'
                                     else
                                       'so'
                                     end

BLIS_VERSION = '0.8.1'
LAPACK_VERSION = '3.10.0'
BLIS_URI = "https://github.com/flame/blis/archive/refs/tags/#{BLIS_VERSION}.tar.gz"
LAPACK_URI = "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v#{LAPACK_VERSION}.tar.gz"
BLIS_TGZ = "#{VENDOR_DIR}/tmp/blis-#{BLIS_VERSION}.tgz"
LAPACK_TGZ = "#{VENDOR_DIR}/tmp/lapack-#{LAPACK_VERSION}.tgz"
BLIS_KEY = 'ce5998fccfac88153f1e52d6497020529a3b5217'
LAPACK_KEY = '4a9384523bf236c83568884e8c62d9517e41ac42'
RB_CC = "'#{RbConfig::expand('$(CC)')}'"
RB_CXX = "'#{RbConfig::expand('$(CPP)')}'"

BLIS_THREADING = if ['openmp', 'pthreads', 'no'].include?(ENABLE_THREADING_ARG)
                   ENABLE_THREADING_ARG
                 elsif try_compile('#include <omp.h>')
                   'openmp'
                 elsif try_complie('#include <pthread.h>')
                   'pthreads'
                 else
                   'no'
                 end
BLIS_CONFIGURE_OPTIONS = ['--enable-cblas',
                          "--enable-threading=#{BLIS_THREADING}",
                          "--prefix=#{VENDOR_DIR}",
                          "CC=#{RB_CC}",
                          "CXX=#{RB_CXX}",
                          'auto'].join(' ')
LAPACK_CMAKE_OPTIONS = ["-DBLAS_LIBRARIES='#{VENDOR_DIR}/lib/libblis.#{SOEXT}'",
                        '-DLAPACKE=ON',
                        '-DBUILD_SHARED_LIBS=ON',
                        '-DCMAKE_BUILD_TYPE=Release',
                        "-DCMAKE_INSTALL_PREFIX='#{VENDOR_DIR}'"].join(' ')

unless File.exist?("#{VENDOR_DIR}/installed_blis-#{BLIS_VERSION}")
  puts "Downloading BLIS #{BLIS_VERSION}."
  URI.parse(BLIS_URI).open { |rf| File.open(BLIS_TGZ, 'wb') { |sf| sf.write(rf.read) } }
  abort('SHA1 digest of downloaded file does not match.') unless BLIS_KEY == Digest::SHA1.file(BLIS_TGZ).to_s

  puts 'Unpacking BLIS tgz file.'
  Gem::Package::TarReader.new(Zlib::GzipReader.open(BLIS_TGZ)) do |tar|
    tar.each do |entry|
      next unless entry.file?

      filename = "#{VENDOR_DIR}/tmp/#{entry.full_name}"
      next if filename == File.dirname(filename)

      FileUtils.mkdir_p("#{VENDOR_DIR}/tmp/#{File.dirname(entry.full_name)}")
      File.open(filename, 'wb') { |f| f.write(entry.read) }
      File.chmod(entry.header.mode, filename)
    end
  end

  Dir.chdir("#{VENDOR_DIR}/tmp/blis-#{BLIS_VERSION}") do
    puts 'Configuring BLIS.'
    cfgstdout, _cfgstderr, cfgstatus = Open3.capture3("./configure #{BLIS_CONFIGURE_OPTIONS}")
    File.open("#{VENDOR_DIR}/tmp/blis.log", 'w') { |f| f.puts(cfgstdout) }
    abort('Failed to config BLIS.') unless cfgstatus.success?

    puts 'Building BLIS. This could take a while...'
    mkstdout, _mkstderr, mkstatus = Open3.capture3('make -j')
    File.open("#{VENDOR_DIR}/tmp/blis.log", 'a') { |f| f.puts(mkstdout) }
    abort('Failed to build BLIS.') unless mkstatus.success?

    puts 'Installing BLIS.'
    insstdout, _insstderr, insstatus = Open3.capture3('make install')
    File.open("#{VENDOR_DIR}/tmp/blis.log", 'a') { |f| f.puts(insstdout) }
    abort('Failed to install BLIS.') unless insstatus.success?

    FileUtils.touch("#{VENDOR_DIR}/installed_blis-#{BLIS_VERSION}")
  end
end

unless File.exist?("#{VENDOR_DIR}/installed_lapack-#{LAPACK_VERSION}")
  puts "Downloading LAPACK #{LAPACK_VERSION}."
  URI.parse(LAPACK_URI).open { |rf| File.open(LAPACK_TGZ, 'wb') { |sf| sf.write(rf.read) } }
  abort('SHA1 digest of downloaded file does not match.') unless LAPACK_KEY == Digest::SHA1.file(LAPACK_TGZ).to_s

  puts 'Unpacking LAPACK tgz file.'
  Gem::Package::TarReader.new(Zlib::GzipReader.open(LAPACK_TGZ)) do |tar|
    tar.each do |entry|
      next unless entry.file?

      filename = "#{VENDOR_DIR}/tmp/#{entry.full_name}"
      next if filename == File.dirname(filename)

      FileUtils.mkdir_p("#{VENDOR_DIR}/tmp/#{File.dirname(entry.full_name)}")
      File.open(filename, 'wb') { |f| f.write(entry.read) }
      File.chmod(entry.header.mode, filename)
    end
  end

  FileUtils.mkdir_p("#{VENDOR_DIR}/tmp/lapack-#{LAPACK_VERSION}/build")
  Dir.chdir("#{VENDOR_DIR}/tmp/lapack-#{LAPACK_VERSION}/build") do
    puts 'Configuring LAPACK.'
    cmkstdout, _cmkstderr, cmkstatus = Open3.capture3("cmake #{LAPACK_CMAKE_OPTIONS} ../")
    File.open("#{VENDOR_DIR}/tmp/lapack.log", 'w') { |f| f.puts(cmkstdout) }
    abort('Failed to config LAPACK.') unless cmkstatus.success?

    puts 'Building LAPACK. This could take a while...'
    mkstdout, _mkstderr, mkstatus = Open3.capture3('make -j')
    File.open("#{VENDOR_DIR}/tmp/lapack.log", 'a') { |f| f.puts(mkstdout) }
    abort('Failed to build LAPACK.') unless mkstatus.success?

    puts 'Installing LAPACK.'
    insstdout, _insstderr, insstatus = Open3.capture3('make install')
    File.open("#{VENDOR_DIR}/tmp/lapack.log", 'a') { |f| f.puts(insstdout) }
    abort('Failed to install BLIS.') unless insstatus.success?

    FileUtils.touch("#{VENDOR_DIR}/installed_lapack-#{LAPACK_VERSION}")
  end
end

abort('libblis is not found.') unless find_library('blis', nil, "#{VENDOR_DIR}/lib")

create_makefile('numo/blis/blisext')
