require 'socket'

require_relative '../Memcached.rb'

module RubyMemcached
    class Server

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
                            client.puts(Server::Errors::SERVER_ERROR % [ e.message ])
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
                when Server::Commands::GET_REGEX
                    self.get(client, $~)
    
                when Server::Commands::GETS_REGEX
                    self.gets(client, $~)
    
                when Server::Commands::SET_REGEX
                    self.set(client, $~)
    
                when Server::Commands::ADD_REGEX
                    self.add(client, $~)
                    
                when Server::Commands::REPLACE_REGEX
                    self.replace(client, $~)
    
                when Server::Commands::APPEND_REGEX
                    self.append(client, $~)
    
                when Server::Commands::PREPEND_REGEX
                    self.prepend(client, $~)
    
                when Server::Commands::CAS_REGEX
                    self.cas(client, $~)

                when Server::Commands::DELETE_REGEX
                    self.delete(client, $~)

                when Server::Commands::END_REGEX
                    return false;
                else
                    client.puts(Server::Errors::CLIENT_ERROR % [": Invalid command"])
            end
            return true
        end
    
        def get_data(client, bytes)
            return client.recv(bytes).chomp()
        end
    
        def get(client, command)
            keys = command['keys'].split(' ')
            items = @memc.get_multi(keys)
    
            for item in items
                client.puts(Server::Responses::GET_RESPONSE % [item.key, item.flags, item.bytes, item.data]) unless item.nil?()
            end
            client.puts(Server::Responses::END_RESPONSE)
        end
    
        def gets(client, command)
            keys = command['keys'].split(' ')
            items = @memc.get_multi(keys)
    
            for item in items
                client.puts(Server::Responses::GETS_RESPONSE % [item.key, item.flags, item.bytes, item.cas_id, item.data]) unless item.nil?()
            end
            client.puts(Server::Responses::END_RESPONSE)
        end
    
        def set(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.set(key, flags, exptime, bytes, data)
            client.puts(server_response(response)) unless noreply
        end
    
        def add(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.add(key, flags, exptime, bytes, data)
            client.puts(server_response(response)) unless noreply
        end
    
        def replace(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.replace(key, flags, exptime, bytes, data)
            client.puts(server_response(response)) unless noreply
        end
    
        def append(client, command)
            key = command['key']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.append(key, bytes, data)
            client.puts(server_response(response)) unless noreply
        end
    
        def prepend(client, command)
            key = command['key']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.prepend(key, bytes, data)
            client.puts(server_response(response)) unless noreply
    
        end
    
        def cas(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            cas_id = command['cas_id'].to_i()
            noreply = !command['noreply'].nil?
    
            response = @memc.cas(key, flags, exptime, bytes, cas_id, data)
            client.puts(server_response(response)) unless noreply
        end

        def delete(client, command)
            key = command['key']
            noreply = !command['noreply'].nil?

            response = @memc.delete(key)
            client.puts(server_response(response)) unless noreply
        end
    
        def server_response(response)
            case response
                when Memcached::Responses.stored
                    Server::Responses::STORED
                when Memcached::Responses.not_stored
                    Server::Responses::NOT_STORED
                when Memcached::Responses.exists
                    Server::Responses::EXISTS
                when Memcached::Responses.not_found
                    Server::Responses::NOT_FOUND
            end
        end

        def start_gc(interval)
            while true
                puts('Garbage collector deleted: %d' % @memc.check_exptimes())
                sleep(interval)
            end
        end
    end
end

require_relative './constants/Commands.rb'
require_relative './constants/Responses.rb'
require_relative './constants/Errors.rb'