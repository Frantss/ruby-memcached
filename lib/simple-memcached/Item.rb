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
        @exptime = exptime
        @cas_id = cas_id

        @lock = Mutex.new()
    end
end