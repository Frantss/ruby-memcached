require 'ruby-enum'

module RubyMemcached
    class Responses
        include Ruby::Enum
    
        define :stored, "STORED\r\n"
        define :not_stored, "NOT_STORED\r\n"
        define :exists, "EXISTS\r\n"
        define :not_found, "NOT_FOUND\r\n"
        define :deleted, "DELETED\r\n"

        define :get, "VALUE %s %d %d\r\n%s\r\n"
        define :gets, "VALUE %s %d %d %d\r\n%s\r\n"
        
        define :end, "END\r\n"
    end
end