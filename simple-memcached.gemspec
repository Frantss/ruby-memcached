Gem::Specification.new do |s|
    s.name        = 'simple-memcached'
    s.version     = '0.0.1'
    s.date        = '2019-12-05'
    s.summary     = 'Simple memcached'
    s.description = 'A simple memcached implementation for Moove-It code challenge'
    s.authors     = ['Francisco Bongiovanni']
    s.email       = 'Frantss.Bongiovanni@gmail.com'
    s.files       = ['lib/simple-memcached.rb', 'lib/simple-memcached/Memcached.rb', 'lib/simple-memcached/Item.rb', 'lib/simple-memcached/Responses.rb', 'lib/simple-memcached/server/Server.rb', 'lib/simple-memcached/server/static/Commands.rb', 'lib/simple-memcached/server/static/Errors.rb', 'lib/simple-memcached/server/static/Responses.rb' ]
    s.executables  = ['Client.rb', 'Server.rb']
    s.homepage    = 'https://rubygems.org/gems/simple-memcached'
    s.license     = 'MIT'
  end