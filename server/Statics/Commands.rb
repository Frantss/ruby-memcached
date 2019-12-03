class Commands
    GET_REGEX = /^get (?<keys>[a-zA-Z0-9 ]+)$/
    GETS_REGEX = /^gets (?<keys>[a-zA-Z0-9 ]+)$/

    SET_REGEX = /^set (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?$/
    ADD_REGEX = /^add (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?$/
    REPLACE_REGEX = /^replace (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?$/

    APPEND_REGEX = /^append (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?$/
    PREPEND_REGEX = /^prepend (?<key>[a-zA-Z0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?$/

    CAS_REGEX = /^cas (?<key>[a-zA-Z0-9]+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+)(?<noreply> noreply)?$/

    DATA_BLOCK_REGEX = /.*$/

    END_REGEX = /END$/
end