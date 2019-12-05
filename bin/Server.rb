#!/usr/bin/env ruby

require_relative '../lib/memcached/server/Server.rb'

puts('Creating server...')
host = ARGV[0]
port = ARGV[1]
server = Memcached::Server.new(host, port)
puts('Starting server...')
server.start()