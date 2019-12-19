require 'ruby-enum'

module RubyMemcached
    class Errors
        include Ruby::Enum

        define :error, "ERROR\r\n"
        define :client_error, "CLIENT_ERROR %s\r\n"
        define :server_error, "SERVER_ERROR %s\r\n"
    end
end