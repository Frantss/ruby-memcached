#!/usr/bin/env ruby

require_relative '../lib/ruby_memcached.rb'
# require 'ruby_memcached'

puts('Creating server...')
host = ARGV[0]
port = ARGV[1]
server = RubyMemcached::Server.new(host, port)
puts('Starting server...')

main = Thread.new {
    server.start()
}

gc = Thread.new {
    server.start_gc()
}

main.join()
# gc.join()   
puts('Server closed')