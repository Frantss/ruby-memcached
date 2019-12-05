require 'ruby-enum'

class Memcached::Responses
    include Ruby::Enum

    define :stored, 'STORED'
    define :not_stored, 'NOT_STORED'
    define :exists, 'EXISTS'
    define :not_found, 'NOT_FOUND'
end