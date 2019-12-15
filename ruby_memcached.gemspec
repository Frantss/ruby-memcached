Gem::Specification.new do |s|
    s.name        = 'ruby-memcached'
    s.version     = '1.0.0.pre'
    s.date        = '2019-12-05'
    s.summary     = 'Simple ruby memcached implementation'
    s.description = 'A simple memcached implementation for Moove-It code challenge'
    s.authors     = ['Francisco Bongiovanni']
    s.email       = 'Frantss.Bongiovanni@gmail.com'
    s.files       = ['lib/ruby-memcached.rb', 'lib/ruby-memcached/Memcached.rb', 'lib/ruby-memcached/Item.rb', 'lib/ruby-memcached/Responses.rb', 'lib/ruby-memcached/server/Server.rb', 'lib/ruby-memcached/server/constants/Commands.rb', 'lib/ruby-memcached/server/constants/Errors.rb', 'lib/ruby-memcached/server/constants/Responses.rb' ]
    s.executables = ['Client.rb', 'Server.rb']
    s.homepage    = 'https://rubygems.org/gems/ruby-memcached'
    s.license     = 'MIT'
    s.metadata    = {
      "github_uri"         => "https://github.com/Frantss/memcached-ruby"
    }
  end