require 'socket'
require_relative 'Statics.rb'

class Server

    def initialize(hostname, port)
        @hostname = hostname
        @port = port
        @connection = TCPServer.new(hostname, port)
        @storage = Hash.new
    end

    def start
        loop do
            Thread.start(@connection.accept()) do | client |
            
                while command = client.gets()
                    printf('Command: %s' % [command])
                end

                client.close()
                puts('Closing connection to %s \n' % [client.to_s])
            end
        end
    end
end