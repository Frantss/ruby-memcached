module RubyMemcached
    class Server::Responses
        STORED = 'STORED\r\n'
        NOT_STORED = 'NOT_STORED\r\n'
        EXISTS = 'EXISTS\r\n'
        NOT_FOUND = 'NOT_FOUND\r\n'
        DELETED = 'DELETED\r\n'
    
        GET_RESPONSE = 'VALUE %s %s %d\r\n%s\r\n'
        GETS_RESPONSE = 'VALUE %s %s %d %d\r\n%s\r\n'
        END_RESPONSE = 'END\r\n'
    end
end