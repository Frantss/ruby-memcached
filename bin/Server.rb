#!/usr/bin/env ruby

require_relative '../lib/ruby_memcached.rb'
# require 'ruby_memcached'

puts('Creating server...')
host = ARGV[0]
port = ARGV[1]
gc_interval = ARGV[2].to_i()

server = RubyMemcached::Server.new(host, port)

main = Thread.new {
    puts('Starting server...')
    server.start()
}

gc = Thread.new {
    server.start_gc(gc_interval) if gc_interval > 0
}

main.join()
puts('Server closed')