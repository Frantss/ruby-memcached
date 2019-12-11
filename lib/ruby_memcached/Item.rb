module RubyMemcached
    class Memcached::Item

        attr_accessor :key
        attr_accessor :data
        attr_accessor :flags
        attr_accessor :exptime
        attr_accessor :bytes
        attr_accessor :cas_id
        
        attr_accessor :lock
    
        def initialize(key, data, flags, exptime, bytes, cas_id)
            @key = key
            @data = data
            @flags = flags
            @bytes = bytes
            @exptime = get_exptime(exptime.to_i)
            @cas_id = cas_id

            @lock = Mutex.new()
        end
    end
end

def get_exptime(exptime)
    if (exptime == 0)
        return nil
    elsif (exptime < 1592000)
        return Time.now().getutc() + exptime
    else
        return Time.at(exptime)
    end
end
