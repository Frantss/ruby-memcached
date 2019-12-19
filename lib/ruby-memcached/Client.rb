require 'socket'

require_relative './Memcached.rb'
require_relative './Constants.rb'

module RubyMemcached
    class Client

        attr_reader :host
        attr_reader :port

        def initialize(host, port)
            @host = host
            @port = port
            @server = TCPSocket.new(host, port)
        end

        def get(keys)
            keys_string = keys.reduce { |ss, s| ss + ' ' + s }
            @server.puts(Commands.get % keys_string)

            items = []

            loop do
                response = @server.gets()
                puts response
                case response
                    when ResponsesRegex.get
                        key = $~['key']
                        flags = $~['flags'].to_i()
                        bytes = $~['bytes'].to_i()
                        data = @server.read(bytes + 1).chomp()

                        items << Memcached::Item.new(key, flags, 0, bytes, nil, data)

                    when ResponsesRegex.end
                        break
                end
            end

            return items
        end

        def gets(keys)
            keys_string = keys.reduce { |ss, s| ss + ' ' + s }
            @server.puts(Commands.gets % key_string)

            items = []

            loop do
                case @server.gets()
                    when ResponsesRegex.gets
                        key = $~['key']
                        flags $~['flags'].to_i()
                        bytes = $~['bytes'].to_i()
                        cas_id = $~['cas_id'].to_i()
                        data = @server.recv(bytes + 1).chomp()

                        items << Memcached::Item.new(key, flags, 0, bytes, cas_id, data)

                    when ResponsesRegex.end
                        break
                end
            end

            return items
        end

        def set(key, flags, exptime, byte, data)
            @server.puts(Commands.set % [
                key,
                flags,
                exptime,
                byte,
                '',
                data
            ])
            
            puts(Commands.set % [
                key,
                flags,
                exptime,
                byte,
                '',
                data
            ]) 

            return Responses.to_h[Responses.key @server.gets()]           
        end

        def add(key, flags, exptime, byte, data)
            @server.puts(Commands.add % [
                key,
                flags,
                exptime,
                byte,
                '',
                data
            ])

            return Responses.to_h[Responses.key @server.gets()]           
        end

        def replace(key, flags, exptime, byte, data)
            @server.puts(Commands.replace % [
                key,
                flags,
                exptime,
                byte,
                '',
                data
            ])

            return Responses.to_h[Responses.key @server.gets()]           
        end

        def append(key, bytes, data)
            @server.puts(Commands.append % [
                key,
                byte,
                '',
                data
            ])

            return Responses.to_h[Responses.key @server.gets()]                       
        end

        def prepend(key, bytes, data)
            @server.puts(Commands.prepend % [
                key,
                byte,
                '',
                data
            ])

            return Responses.to_h[Responses.key @server.gets()]                       
        end

        def cas(key, flags, exptime, byte, cas_id, data)
            @server.puts(Commands.replace % [
                key,
                flags,
                exptime,
                byte,
                cas_id,
                '',
                data
            ])

            return Responses.to_h[Responses.key @server.gets()]           
        end

        def delete(key)
            @server.puts(Commands.delete % key)
            return Responses.to_h[Responses.key @server.gets()]        
        end
    end
end
