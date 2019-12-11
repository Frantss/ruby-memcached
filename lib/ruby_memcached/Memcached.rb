require 'concurrent'

module RubyMemcached
    class Memcached

        attr_reader :storage
    
        def initialize
            @storage = Concurrent::Hash.new()
        end
    
        def get(key)
            return @storage[key]
        end
    
        def get_multi(keys)
            result = []
            for key in keys do
                item = self.get(key)
                result.append(item) unless item.nil?
            end
            return result
        end
    
        def set(key, flags, exptime, bytes, data)
            if(@storage.key?(key))
                cas_id = @storage[key].cas_id + 1
            else
                cas_id = 0
            end
            new_item = Item.new(key, data, flags, exptime, bytes, cas_id)
            @storage.store(key, new_item)
            return Responses::stored
        end
    
        def add(key, flags, exptime, bytes, data)
            return Responses.not_stored if @storage.key?(key)
            new_item = Item.new(key, data, flags, exptime, bytes, 0)
            @storage.store(key, new_item)
            return Responses.stored
        end
    
        def replace(key, flags, exptime, bytes, data)
            return Responses.not_stored if not @storage.key?(key)
            cas_id = @storage[key].cas_id + 1
            new_item = Item.new(key, data, flags, exptime, bytes, cas_id)
            @storage.store(key, new_item)
            return Responses.stored
        end
    
        def append(key, bytes, data)
            return Responses.not_stored if not @storage.key?(key)
            @storage[key].data.concat(data)
            @storage[key].cas_id += 1
            return Responses.stored
        end
    
        def prepend(key, bytes, data)
            return Responses.not_stored if not @storage.key?(key)
            @storage[key].data.prepend(data)
            @storage[key].cas_id += 1
            return Responses.stored
        end
    
        def cas(key, flags, exptime, bytes, cas_id, data)
            return Responses.not_found if not @storage.key?(key)
            
            old_item = @storage[key]
            old_item.lock.synchronize do
                return Responses.exists if old_item.cas_id != cas_id
    
                new_item = Item.new(key, data, flags, exptime, bytes, old_item.cas_id + 1)
                @storage.store(key, new_item)
                return Responses.stored
            end
        end
    end    
end

require_relative './Item.rb'
require_relative './Responses.rb'