require 'ruby-enum'

module RubyMemcached
    class Commands
        include Ruby::Enum

        define :get, "get %s\r\n"
        define :gets, "gets %s\r\n"

        define :set, "set %s %d %d %d%s\r\n%s\r\n"
        define :add, "add %s %d %d %d%s\r\n%s\r\n"
        define :replace, "replace %s %d %d %d%s\r\n%s\r\n"

        define :append, "append %s %d%s\r\n%s\r\n"
        define :prepend, "prepend %s %d%s\r\n%s\r\n"

        define :cas, "cas %s %d %d %d%s\r\n%s\r\n"

        define :delete, "delete %s%s\r\n"

        define :incr, "incr %s %d%s\r\n%d\r\n"
        define :decr, "decr %s %d%s\r\n%d\r\n"
    end
end
