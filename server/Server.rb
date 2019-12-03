require 'socket'
require_relative './Statics/Commands.rb'
require_relative './Statics/Responses.rb'
require_relative './Statics/Errors.rb'
require_relative './Item.rb'

class Server

    attr_reader :hostname
    attr_reader :port
    attr_accessor :storage

    def initialize(hostname, port)
        @hostname = hostname
        @port = port
        @connection = TCPServer.new(hostname, port)
        @storage = Hash.new()
    end

    def start
        loop do
            Thread.start(@connection.accept()) do | client |
            
                puts('Opening connection to %s \n' % [client.to_s])

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
        when Commands::GET_REGEX
            keys = $~['keys'].split(' ')
            self.get(client, keys)

        when Commands::GETS_REGEX
            keys = $~['keys'].split(' ')
            self.gets(client, keys)

        when Commands::SET_REGEX
            key = $~['key']
            flags = $~['flags']
            exptime = $~['exptime']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = $~['noreply'].nil?

            self.set(client, key, flags, exptime, bytes, data, noreply)

        when Commands::ADD_REGEX
            key = $~['key']
            flags = $~['flags']
            exptime = $~['exptime']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = $~['noreply'].nil?

            self.add(key, flags, exptime, bytes, data, noreply)
            
        when Commands::REPLACE_REGEX
            key = $~['key']
            flags = $~['flags']
            exptime = $~['exptime']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = $~['noreply'].nil?

            self.replace(key, flags, exptime, bytes, data, noreply)

        when Commands::APPEND_REGEX
            key = $~['key']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = $~['noreply'].nil?

            self.append(client, key, bytes, data, noreply)

        when Commands::PREPEND_REGEX
            key = $~['key']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = $~['noreply'].nil?

            self.prepend(client, key, bytes, data, noreply)

        when Commands::CAS_REGEX
            key = $~['key']
            flags = $~['flags']
            exptime = $~['exptime']
            bytes = $~['bytes'].to_i()
            data = self.get_data(client, bytes)
            cas_id = $~['cas_id'].to_i()
            noreply = $~['noreply'].nil?

            self.cas(key, flags, exptime, bytes, data, noreply)

        when Commands::END_REGEX
            return false;
        else
            client.puts(Errors::CLIENT_ERROR % [": Invalid command"])
        end
    end

    def get_data(client, bytes)
        return "TEST"
    end

    def get(client, keys)
        for key in keys do
            item = self.storage[key]
            client.puts(Responses::GET_RESPONSE % [key, item.flags, item.bytes, item.data]) unless item.nil?
        end

        client.puts(Responses::END_RESPONSE)
    end

    def gets(client, keys)
        for key in keys do
            item = self.storage[key]
            client.puts(Responses::GETS_RESPONSE % [key, item.flags, item.bytes, item.cas_id, item.data]) unless item.nil?
        end

        client.puts(Responses::END_RESPONSE)
    end

    def set(client, key, flags, exptime, bytes, data, noreply = false)
        item = Item.new(data, flags, exptime, bytes, 0)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses::STORED) unless noreply
    end

    def add(client, key, flags, exptime, bytes, data, noreply = false)
        if(@storage.key?(key))
            client.puts(Responses::NOT_STORED) unless noreply
            return
        end
        item = Item.new(data, flags, exptime, bytes)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses::STORED) unless noreply
    end

    def replace(client, key, flags, exptime, bytes, data, noreply = false)
        if(not @storage.key?(key))
            client.puts(Responses::NOT_STORED) unless noreply
            return
        end
        item = Item.new(data, flags, exptime, bytes)
        # TODO: Check flags
        @storage.store(key, item)
        client.puts(Responses::STORED) unless noreply
    end

    def append(client, key, bytes, data, noreply = false)
        if(not @storage.key?(key))
            client.puts(Responses::NOT_STORED) unless noreply
            return
        end
        @storage[key].append(data)
        client.puts(Responses::STORED) unless noreply
    end

    def prepend(client, key, bytes, data, noreply = false)
        if(not @storage.key?(key))
            client.puts(Responses::NOT_STORED) unless noreply
            return
        end
        @storage[key].prepend(data)
        client.puts(Responses::STORED) unless noreply
    end

    def cas(client, key, flags, exptime, bytes, cas_id, data, noreply = false)
        
    end
end