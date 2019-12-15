module RubyMemcached
    class Server::Commands
        GET_REGEX = /^get (?<keys>(\w|[ ])+)\n/
        GETS_REGEX = /^gets (?<keys>(\w|[ ])+)\n/
    
        SET_REGEX = /^set (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        ADD_REGEX = /^add (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        REPLACE_REGEX = /^replace (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        APPEND_REGEX = /^append (?<key>(\w)+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        PREPEND_REGEX = /^prepend (?<key>(\w)+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        CAS_REGEX = /^cas (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+)(?<noreply> noreply)?\n/

        DELETE_REGEX = /^delete (?<key>(\w)+)(?<noreply> noreply)?\n/
        INCR_REGEX = /^incr (?<key>(\w)+) (?<value>[0-9]+)(?<noreply> noreply)?\n/
        DECR_REGEX = /^decr (?<key>(\w)+) (?<value>[0-9]+)(?<noreply> noreply)?\n/

        DATA_BLOCK_REGEX = /.*\n/
    
        END_REGEX = /END\n/
    end
end