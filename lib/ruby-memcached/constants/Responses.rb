require 'ruby-enum'

module RubyMemcached
    class Responses
        include Ruby::Enum
    
        define :stored, "STORED\n"
        define :not_stored, "NOT_STORED\n"
        define :exists, "EXISTS\n"
        define :not_found, "NOT_FOUND\n"
        define :deleted, "DELETED\n"

        define :get, "VALUE %s %d %d\n%s\n"
        define :gets, "VALUE %s %d %d %d\n%s\n"
        
        define :end, "END\n"
    end
end