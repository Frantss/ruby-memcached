require 'ruby-enum'

module RubyMemcached
    class Commands
        include Ruby::Enum

        define :get, "get %s\n"
        define :gets, "gets %s\n"

        define :set, "set %s %d %d %d%s\n%s\n"
        define :add, "add %s %d %d %d%s\n%s\n"
        define :replace, "replace %s %d %d %d%s\n%s\n"

        define :append, "append %s %d%s\n%s\n"
        define :_prepend, "prepend %s %d%s\n%s\n"

        define :cas, "cas %s %d %d %d %d%s\n%s\n"

        define :delete, "delete %s%s\n"

        define :incr, "incr %s %d%s\n%d\n"
        define :decr, "decr %s %d%s\n%d\n"

        define :end, "END\n"
    end
end
