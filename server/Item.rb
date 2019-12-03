class Item

    attr_accessor :data
    attr_accessor :flags
    attr_accessor :exptime
    attr_accessor :bytes
    attr_accessor :cas_id
    
    def initialize(data, flags, exptime, bytes, cas_id)
        @data = data
        @flags = flags
        @bytes = bytes
        @exptime = exptime
        @cas_id = cas_id
    end
end