require_relative 'Server.rb'

puts('Creating server...')
server = Server.new('localhost', 5001)
puts('Starting server...')
server.start()