require 'socket'
require 'concurrent'
require_relative './static/Commands.rb'
require_relative './static/Responses.rb'
require_relative './static/Errors.rb'

class Memcached::Server

    attr_reader :hostname
    attr_reader :port
    attr_accessor :storage

    def initialize(hostname, port)
        @hostname = hostname
        @port = port
        @connection = TCPServer.new(hostname, port)
        @memc = Memcached.new()
    end

    def start
        loop do
            Thread.start(@connection.accept()) do | client |
            
                puts('Opening connection to %s' % [client.to_s])

                continue_condition = true

                while command = client.gets()
                    printf('%s: %s' % [client.to_s(), command])
                    begin
                        continue_condition = parse(command, client) unless command.nil?                        
                    rescue => e
                        client.puts(Errors::SERVER_ERROR % [ e.message ])
                    end
                    break unless continue_condition
                end

                client.close()
                puts('Closing connection to %s' % [client.to_s()])
            end
        end
    end

    def parse(command, client)
        case command
        when Commands::GET_REGEX
            self.get(client, $~)

        when Commands::GETS_REGEX
            self.gets(client, $~)

        when Commands::SET_REGEX
            self.set(client, $~)

        when Commands::ADD_REGEX
            self.add(client, $~)
            
        when Commands::REPLACE_REGEX
            self.replace(client, $~)

        when Commands::APPEND_REGEX
            self.append(client, $~)

        when Commands::PREPEND_REGEX
            self.prepend(client, $~)

        when Commands::CAS_REGEX
            self.cas(client, $~)

        when Commands::END_REGEX
            return false;
        else
            client.puts(Errors::CLIENT_ERROR % [": Invalid command"])
        end
        return true
    end

    def get_data(client, bytes)
        return client.recv(bytes).chomp()
    end

    def get(client, cmd)
        keys = cmd['keys'].split(' ')
        items = @memc.get_multi(keys)

        for item in items
            client.puts(Responses::GET_RESPONSE % [item.key, item.flags, item.bytes, item.data]) unless item.nil?()
        end
        client.puts(Responses::END_RESPONSE)
    end

    def gets(client, cmd)
        keys = cmd['keys'].split(' ')
        items = @memc.get_multi(keys)

        for item in items
            client.puts(Responses::GETS_RESPONSE % [item.key, item.flags, item.bytes, item.cas_id, item.data]) unless item.nil?()
        end
        client.puts(Responses::END_RESPONSE)
    end

    def set(client, cmd)
        key = cmd['key']
        flags = cmd['flags']
        exptime = cmd['exptime']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        noreply = !cmd['noreply'].nil?

        response = @memc.set(key, flags, exptime, bytes, data)
        client.puts(server_response(response)) unless noreply
    end

    def add(client, cmd)
        key = cmd['key']
        flags = cmd['flags']
        exptime = cmd['exptime']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        noreply = !cmd['noreply'].nil?

        response = @memc.add(key, flags, exptime, bytes, data)
        client.puts(server_response(response)) unless noreply
    end

    def replace(client, cmd)
        key = cmd['key']
        flags = cmd['flags']
        exptime = cmd['exptime']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        noreply = !cmd['noreply'].nil?

        response = @memc.replace(key, flags, exptime, bytes, data)
        client.puts(server_response(response)) unless noreply
    end

    def append(client, cmd)
        key = cmd['key']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        noreply = !cmd['noreply'].nil?

        response = @memc.append(key, bytes, data)
        client.puts(server_response(response)) unless noreply
    end

    def prepend(client, cmd)
        key = cmd['key']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        noreply = !cmd['noreply'].nil?

        response = @memc.prepend(key, bytes, data)
        client.puts(server_response(response)) unless noreply

    end

    def cas(client, cmd)
        key = cmd['key']
        flags = cmd['flags']
        exptime = cmd['exptime']
        bytes = cmd['bytes'].to_i()
        data = self.get_data(client, bytes)
        cas_id = cmd['cas_id'].to_i()
        noreply = !cmd['noreply'].nil?

        response = @memc.cas(key, flags, exptime, bytes, cas_id, data)
        client.puts(server_response(response)) unless noreply
    end

    def server_response(response)
        case response
        when Memcached::Responses.stored
            Responses::STORED
        when Memcached::Responses.not_stored
            Responses::NOT_STORED
        when Memcached::Responses.exists
            Responses::EXISTS
        when Memcached::Responses.not_found
            Responses::NOT_FOUND
        end
    end
end