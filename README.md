# RubyMemcached

A simple memcached ruby implementation.
Coded as part of [Moove-It coding-challenges](https://github.com/moove-it/coding-challenges/blob/master/ruby.md)

## Gem Installation

The solution is uploaded to [RubyGems](https://rubygems.org/) at [ruby-memcached](https://rubygems.org/gems/ruby-memcached)

```cmd
gem install ruby-memcached
```

## Testing

Inside the root folder use the command `rake` to run all included tests.

## Executables

#### Server

A memcached server can be quickly deployed using the following command on the console:

```cmd
memcached-server <host> <port> [gb_interval]

memcached-server localhost 5001       ~> Example
memcached-server localhost 5001 20    ~> Example
```

- Where
  - `<host>` is IP which the server will use.
  - `<port>` is the port where from which the server communicates with the clients.
  - `gb_interval` is the time in seconds between calls to the garbage collector.

#### Client

A console client to a memcached server can be deploy using the following command:

```cmd
memcached-client <host> <port>

memcached-client localhost 5001       ~> Example
```

- Where
  - `<host>` is IP of the server.
  - `<port>` is the port of the server.

## Usage

#### Memcached

Object that holds implements the logic of the memcached protocol. Can be used as a storage structure, does't need a server deployment.

```ruby
require 'ruby-memcached'
include RubyMemcached

memc = Memcached.new()
memc.set('test_key', 0, 3600, 4, 'test')
memc.replace('test_key', 0, 3600, 5, 'test2')
memc.prepend('test_key', 6, 'START_')
memc.append('test_key', 4, '_END')
memc.get('test_key').data    #=> START_test2_END
```

#### Server

Class that wraps a Memcaced object and makes it available on a given TCP connection.

```ruby
require 'ruby-memcached'
include RubyMemcached

s = Server.new('localhost', 5001)

st = Thread.new {
    s.start() #=> Starts server
}

Thread.new {
    s.start_gc(5) #=> Starts servers' garbage collector with an interval of 5 seconds between calls
}

st.join()
```

#### Client

Class to connect to the memcached server.

```ruby
require 'ruby-memcached'
include RubyMemcached

st = Thread.new {
    Server.new('localhost', 5001).start()
}

c = Client.new('localhost', 5001)
c.set('test_key', 0, 3600, 4, 'test')
c.replace('test_key', 0, 3600, 5, 'test2')

c.reconnect() #=> Recreates the TCP socket connection to the Server

c.prepend('test_key', 6, 'START_')
c.append('test_key', 4, '_END')
puts c.get(['test_key']).first.data    #=> START_test2_END

c.end() #=> Closes the connection to the server
st.exit()
```

## Class structure

![alt text](https://github.com/Frantss/ruby-memcached/blob/master/other/Class-diagram.md "Class diagram")
