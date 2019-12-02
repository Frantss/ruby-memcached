class Commands
    GET_REGEX = /^get (?<keys>[a-zA-Z0-9 ]+)$/
    GETS_REGEX = /^gets (?<keys>[a-zA-Z0-9 ]+)$/

    SET_REGEX = /^set (?<key>[a-zA-Z0-9]+) (?<flag>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<noreply>noreply)?$/
    ADD_REGEX = /^add (?<key>[a-zA-Z0-9]+) (?<flag>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<noreply>noreply)?$/
    REPLACE_REGEX = /^replace (?<key>[a-zA-Z0-9]+) (?<flag>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<noreply>noreply)?$/

    APPEND_REGEX = /^append (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+) (?<noreply>noreply)?$/
    PREPEND_REGEX = /^prepend (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+) (?<noreply>noreply)?$/

    CAS_REGEX = /^cas (?<key>[a-zA-Z0-9]+) (?<flag>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+) (?<noreply>noreply)?$/

    DATA_BLOCK_REGEX = /.*$/

    END_REGEX = /END$/
end

class Responses
    STORED = "STORED\r\n"
    NOT_STORED = "NOT_STORED\r\n"
    EXISTS = "EXISTS\r\n"
    NOT_FOUND = "NOT_FOUND\r\n"

    GET_RESPONSE = "VALUE %s %s %d\r\n%s\r\n"
    GETS_RESPONSE = "VALUE %s %s %d %d\r\n%s\r\n"
    END_RESPONSE = "END\r\n"
end

class Errors
    ERROR = "ERROR\r\n"
    CLIENT_ERROR = "CLIENT_ERROR %s\r\n"
    SERVER_ERROR = "SERVER_ERROR %S\r\n"
end