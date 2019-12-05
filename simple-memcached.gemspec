Gem::Specification.new do |s|
    s.name        = 'simple-memcached'
    s.version     = '0.0.1'
    s.date        = '2019-12-05'
    s.summary     = 'Simple memcached'
    s.description = 'A simple memcached implementation for Moove-It code challenge'
    s.authors     = ['Francisco Bongiovanni']
    s.email       = 'Frantss.Bongiovanni@gmail.com'
    s.files       = ['lib/Memcached.rb', 'lib/memcached/Item.rb', 'lib/memcached/Responses.rb', 'lib/memcached/server/Server.rb', 'lib/memcached/server/static/Commands.rb', 'lib/memcached/server/static/Errors.rb', 'lib/memcached/server/static/Responses.rb' ]
    s.executables  = ['Client.rb', 'Server.rb']
    s.homepage    = 'https://rubygems.org/gems/simple-memcached'
    s.license     = 'MIT'
  end