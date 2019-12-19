require 'ruby-enum'

module RubyMemcached
    class ResponsesRegex
        include Ruby::Enum

        define :get, /VALUE (?<key>(\w)+) (?<flags>[0-9]+) (?<bytes>[0-9]+)/
        define :gets, /VALUE (?<key>(\w)+) (?<flags>[0-9]+) (?<bytes>[0-9]+) (?<cas_id>[0-9]+)/
    
        define :end, /END/
    end
end