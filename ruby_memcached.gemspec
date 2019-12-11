Gem::Specification.new do |s|
    s.name        = 'ruby_memcached'
    s.version     = '0.0.1'
    s.date        = '2019-12-05'
    s.summary     = 'Simple ruby memcached implementation'
    s.description = 'A simple memcached implementation for Moove-It code challenge'
    s.authors     = ['Francisco Bongiovanni']
    s.email       = 'Frantss.Bongiovanni@gmail.com'
    s.files       = ['lib/ruby_memcached.rb', 'lib/ruby_memcached/Memcached.rb', 'lib/ruby_memcached/Item.rb', 'lib/ruby_memcached/Responses.rb', 'lib/ruby_memcached/server/Server.rb', 'lib/ruby_memcached/server/Commands.rb', 'lib/ruby_memcached/server/Errors.rb', 'lib/ruby_memcached/server/Responses.rb' ]
    s.executables = ['Client.rb', 'Server.rb']
    s.homepage    = 'https://rubygems.org/gems/ruby_memcached'
    s.license     = 'MIT'
    s.metadata    = {
      "github_uri"         => "https://github.com/Frantss/memcached-ruby"
    }
  end