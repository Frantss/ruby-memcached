class Item
    
    def initialize(data, flags, exptime, bytes, cas_id)
        @data = data
        @flags = flags
        @bytes = bytes
        @exptime = exptime
        @cas_id = cas_id
    end
end