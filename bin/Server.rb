#!/usr/bin/env ruby

require 'ruby_memcached'

puts('Creating server...')
host = ARGV[0]
port = ARGV[1]
server = RubyMemcached::Server.new(host, port)
puts('Starting server...')
server.start()