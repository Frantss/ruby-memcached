require 'socket'

require_relative './/Memcached.rb'
require_relative './constants/CommandsRegex.rb'
require_relative './constants/Responses.rb'
require_relative './constants/Errors.rb'

module RubyMemcached
    class Server

        attr_reader :host
        attr_reader :port
        attr_accessor :storage
    
        def initialize(host, port)
            @host = host
            @port = port
            @connection = TCPServer.new(host, port)
            @memc = Memcached.new()
        end

        def start
            loop do
                Thread.start(@connection.accept()) do | client |
                
                    puts('Opening connection to %s' % client.to_s)
    
                    continue_condition = true
    
                    while command = client.gets()
                        printf('%s: %s' % [client.to_s(), command])
                        begin
                            continue_condition = parse(command, client) unless command.nil?                        
                        rescue => e
                            client.puts(Errors.server_error % e.message)
                            puts(Errors.server_error % e.message)
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
                when CommandsRegex.get
                    self.get(client, $~)
    
                when CommandsRegex.gets
                    self.gets(client, $~)
    
                when CommandsRegex.set
                    self.set(client, $~)
    
                when CommandsRegex.add
                    self.add(client, $~)
                    
                when CommandsRegex.replace
                    self.replace(client, $~)
    
                when CommandsRegex.append
                    self.append(client, $~)
    
                when CommandsRegex.prepend
                    self.prepend(client, $~)
    
                when CommandsRegex.cas
                    self.cas(client, $~)

                when CommandsRegex.delete
                    self.delete(client, $~)

                when CommandsRegex.end
                    return false;
                else
                    client.puts(Errors.client_error % [": Invalid command"])
            end
            
            return true
        end
    
        def get_data(client, bytes)
            return client.read(bytes + 1).chomp()
        end
    
        def get(client, command)
            keys = command['keys'].split(' ')
            items = @memc.get_multi(keys)
    
            for item in items
                client.puts(Responses.get % [item.key, item.flags, item.bytes, item.data]) unless item.nil?()
            end
            client.puts(Responses.end)
        end
    
        def gets(client, command)
            keys = command['keys'].split(' ')
            items = @memc.get_multi(keys)
    
            for item in items
                client.puts(Responses.get % [item.key, item.flags, item.bytes, item.cas_id, item.data]) unless item.nil?()
            end
            client.puts(Responses.end)
        end
    
        def set(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.set(key, flags, exptime, bytes, data)
            client.puts(response) unless noreply
        end
    
        def add(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.add(key, flags, exptime, bytes, data)
            client.puts(response) unless noreply
        end
    
        def replace(client, command)
            key = command['key']
            flags = command['flags']
            exptime = command['exptime']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.replace(key, flags, exptime, bytes, data)
            client.puts(response) unless noreply
        end
    
        def append(client, command)
            key = command['key']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.append(key, bytes, data)
            client.puts(response) unless noreply
        end
    
        def prepend(client, command)
            key = command['key']
            bytes = command['bytes'].to_i()
            data = self.get_data(client, bytes)
            noreply = !command['noreply'].nil?
    
            response = @memc.prepend(key, bytes, data)
            client.puts(response) unless noreply
    
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
            client.puts(response) unless noreply
        end

        def delete(client, command)
            key = command['key']
            noreply = !command['noreply'].nil?

            response = @memc.delete(key)
            client.puts(response) unless noreply
        end

        def start_gc(interval, loops = nil)

            while loops.nil?() || loops > 0
                sleep(interval)
                puts('Garbage collector deleted: %d' % @memc.check_exptimes())
                loops -= 1 unless loops.nil?()
            end
        end
    end
end
