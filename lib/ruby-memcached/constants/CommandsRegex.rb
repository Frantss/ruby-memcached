require 'ruby-enum'

module RubyMemcached
    class CommandsRegex
        include Ruby::Enum

        define :get, /^get (?<keys>(\w|[ ])+)\n/
        define :gets, /^gets (?<keys>(\w|[ ])+)\n/
    
        define :set, /^set (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        define :add, /^add (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        define :replace, /^replace (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        define :append, /^append (?<key>(\w)+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
        define :prepend, /^prepend (?<key>(\w)+) (?<bytes>[0-9]+)(?<noreply> noreply)?\n/
    
        define :cas, /^cas (?<key>(\w)+) (?<flags>[0-9]+) (?<exptime>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+)(?<noreply> noreply)?\n/

        define :delete, /^delete (?<key>(\w)+)(?<noreply> noreply)?\n/

        define :incr, /^incr (?<key>(\w)+) (?<value>[0-9]+)(?<noreply> noreply)?\n/
        define :decr, /^decr (?<key>(\w)+) (?<value>[0-9]+)(?<noreply> noreply)?\n/

        define :end, /END\n/
    end
end