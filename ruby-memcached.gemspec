require 'rake'

Gem::Specification.new do |spec|
    spec.name        = 'ruby-memcached'
    spec.version     = '1.0.0.pre'
    spec.date        = '2019-12-05'
    spec.summary     = 'Simple ruby memcached implementation'
    spec.description = 'A simple memcached implementation for Moove-It code challenge'
    spec.authors     = ['Francisco Bongiovanni']
    spec.email       = 'Frantss.Bongiovanni@gmail.com'
    spec.files       = FileList[ 'lib/**.rb', 'lib/ruby-memcached/**.rb', 'lib/ruby-memcached/constants/**.rb'].to_a()
    spec.executables = ['memcached-client.rb', 'memcached-server.rb']
    spec.homepage    = 'https://rubygems.org/gems/ruby-memcached'
    spec.license     = 'MIT'
    spec.metadata    = {
      "github_uri"         => "https://github.com/Frantss/memcached-ruby"
    }

    spec.add_dependency 'ruby-enum', '~> 0.7.2'
    spec.add_dependency 'concurrent-ruby', '~> 1.1', '>= 1.1.5'

    spec.add_development_dependency 'rake', '~> 12.3'
    spec.add_development_dependency 'minitest', '~> 5.11'
  end