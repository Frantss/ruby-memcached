require 'socket'
require_relative 'Statics.rb'

class Server

    def initialize(hostname, port)
        @hostname = hostname
        @port = port
        @connection = TCPServer.new(hostname, port)
        @storage = Hash.new()
    end

    def start
        loop do
            Thread.start(@connection.accept()) do | client |
            
                while command = client.gets()
                    printf('Command: %s' % [command])
                    parse(command, client) unless command.nil?
                end

                client.close()
                puts('Closing connection to %s \n' % [client.to_s])
            end
        end
    end

    def parse(command, client)
        case command
        when Commands.GET_REGEX
        when Commands.GETS_REGEX
        when Commands.SET_REGEX
        when Commands.ADD_REGEX
        when Commands.REPLACE_REGEX
        when Commands.APPEND_REGEX
        when Commands.PREPEND_REGEX
        when Commands.CAS_REGEX
        when Commands.END_REGEX
            return false;
        else
            client.puts(Errors.ERROR)
        end
    end

    def get(client, keys)
        for key in keys do
            item = self.storage[key]
            client.puts(Responses.GET_RESPONSE % [key, item.flags, item.bytes, item.data]) unless item.nil?
        end        
    end

    def gets(client, keys)
        for key in keys do
            item = self.storage[key]
            client.puts(Responses.GETS_RESPONSE % [key, item.flags, item.bytes, item.cas_id, item.data]) unless item.nil?
        end
    end

    def set(client, key, flags, exptime, bytes, data, noreply = false)
        item = Item.new(data, flags, exptime, bytes)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses.STORED) unless noreply
    end

    def add(client, key, flags, exptime, bytes, data, noreply = false)
        if(@storage.key?(key))
            client.puts(Responses.NOT_STORED) unless noreply
            return
        end
        item = Item.new(data, flags, exptime, bytes)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses.STORED) unless noreply
    end

    def replace(client, key, flags, exptime, bytes, data, noreply = false)
        if(not @storage.key?(key))
            client.puts(Responses.NOT_STORED) unless noreply
            return
        end
        item = Item.new(data, flags, exptime, bytes)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses.STORED) unless noreply
    end

    def append(client, key, bytes, data, noreplay = false)
        if(not @storage.key?(key))
            client.puts(Responses.NOT_STORED) unless noreply
            return
        end
        @storage[key].append(data)
        client.puts(Responses.STORED) unless noreply
    end

    def append(client, key, bytes, data, noreplay = false)
        if(not @storage.key?(key))
            client.puts(Responses.NOT_STORED) unless noreply
            return
        end
        @storage[key].prepend(data)
        client.puts(Responses.STORED) unless noreply
    end
end