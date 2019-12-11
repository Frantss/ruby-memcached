module RubyMemcached
    class Server::Commands
        GET_REGEX = /^get (?<keys>[a-zA-Z0-9 ]+)\n/
        GETS_REGEX = /^gets (?<keys>[a-zA-Z0-9 ]+)\n/
    
        SET_REGEX = /^set (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        ADD_REGEX = /^add (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        REPLACE_REGEX = /^replace (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        APPEND_REGEX = /^append (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        PREPEND_REGEX = /^prepend (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        CAS_REGEX = /^cas (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+)(?<noreply> noreply)?\n/
    
        DATA_BLOCK_REGEX = /.*\n/
    
        END_REGEX = /END\n/
    end
end