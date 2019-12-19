require 'concurrent'

module RubyMemcached
    class Memcached

        attr_reader :storage
    
        def initialize
            @storage = Concurrent::Hash.new()
        end
    
        def get(key)
            self.check_exptime(key)
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
            return Responses.stored
        end
    
        def add(key, flags, exptime, bytes, data)
            self.check_exptime(key)

            return Responses.not_stored if @storage.key?(key)
            new_item = Item.new(key, data, flags, exptime, bytes, 0)
            @storage.store(key, new_item)
            return Responses.stored
        end
    
        def replace(key, flags, exptime, bytes, data)
            self.check_exptime(key)

            return Responses.not_stored unless @storage.key?(key)
            cas_id = @storage[key].cas_id + 1
            new_item = Item.new(key, data, flags, exptime, bytes, cas_id)
            @storage.store(key, new_item)
            return Responses.stored
        end
    
        def append(key, bytes, data)
            self.check_exptime(key)

            return Responses.not_stored unless @storage.key?(key)
            @storage[key].data.concat(data)
            @storage[key].cas_id += 1
            return Responses.stored
        end
    
        def prepend(key, bytes, data)
            self.check_exptime(key)

            return Responses.not_stored unless @storage.key?(key)
            @storage[key].data.prepend(data)
            @storage[key].cas_id += 1
            return Responses.stored
        end
    
        def cas(key, flags, exptime, bytes, cas_id, data)
            self.check_exptime(key)

            return Responses.not_found unless @storage.key?(key)
            
            old_item = @storage[key]
            old_item.lock.synchronize do
                return Responses.exists if old_item.cas_id != cas_id
    
                new_item = Item.new(key, data, flags, exptime, bytes, old_item.cas_id + 1)
                @storage.store(key, new_item)
                return Responses.stored
            end
        end

        def delete(key)
            return Responses.not_found unless @storage.key?(key)
            @storage.delete(key)
            return Responses.deleted
        end

        def check_exptime(key)
            value = @storage[key]
            return true if value.nil?() || value.exptime.nil?()

            current_time = Time.now().getutc()

            if (current_time > value.exptime)
                @storage.delete(key)
                return false
            end 

            return true
        end

        def check_exptimes()
            deleted = 0
            @storage.each_key do | key |
                delete += 1 unless self.check_exptime(key)
            end
            return deleted
        end
    end
end

require_relative './Item.rb'