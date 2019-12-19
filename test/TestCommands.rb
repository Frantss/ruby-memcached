require_relative '../lib/ruby-memcached.rb'
include RubyMemcached

require 'minitest/autorun'

class TestCommands < Minitest::Test


    def test_set_setting_item
        memc = Memcached.new()

        ret_value = memc.set('test_key', 0, 3600, 4, 'test_data')
        assert_equal(Responses.stored, ret_value, 'Error on adding value, unexpected enum returned')
        refute_nil(memc.storage['test_key'], 'Error on adding value, value not added')
    end

    def test_get_getting_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 4, 'test_data')

        actual = memc.get('test_key').data
        assert_equal('test_data', actual, 'Error on getting a value, wrong value returned')
    end

    def test_get_multi_getting_2_items
        memc = Memcached.new()
        memc.set('test_key_1', 0, 3600, 4, 'test_data_1')
        memc.set('test_key_2', 0, 3600, 4, 'test_data_2')

        actual = memc.get_multi(['test_key_1', 'test_key_2']).map { |item| item.data}
        assert_equal(['test_data_1', 'test_data_2'], actual, 'Error on getting multiple values, wrong values returned')
    end
    
    def test_get_multi_getting_3_items_with_one_not_stored
        memc = Memcached.new()
        memc.set('test_key_1', 0, 3600, 4, 'test_data_1')
        memc.set('test_key_3', 0, 3600, 4, 'test_data_3')

        actual = memc.get_multi(['test_key_1', 'test_key_3']).map { |item| item.data}
        assert_equal(['test_data_1', 'test_data_3'], actual, 'Error on getting multiple values, wrong values returned')
    end

    def test_add_adding_not_existing_item
        memc = Memcached.new()
        ret_value = memc.add('test_key', 0, 3600, 4, 'test_data')
        assert_equal(Responses.stored, ret_value, 'Error on adding value, unexpected enum returned')
        
        actual = memc.storage['test_key']
        refute_nil(actual, 'Error on adding value, value not added')
    end

    def test_add_adding_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        ret_value = memc.add('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.not_stored, ret_value, 'Error on adding value, unexpected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('test_data_old', actual, 'Error on adding value, value changed') if ret_value != Responses.stored
        refute_equal('test_data_new', actual, 'Error on adding value, value changed')
    end

    def test_replace_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        ret_value = memc.replace('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.stored, ret_value, 'Error on replacing value, unexpected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('test_data_new', actual, 'Error on replacing value, value didn`t changed')
    end

    def test_replace_not_existing_item
        memc = Memcached.new()

        ret_value = memc.replace('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.not_stored, ret_value, 'Error on replacing value, unexpected enum returned')

        actual = memc.storage['test_key']
        assert_nil(actual, 'Error on replacing value, unexisting value was set by replace method')
    end

    def test_prepend_to_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 9, 'test_data')

        ret_value = memc.prepend('test_key', 7, 'prefix_')
        assert_equal(Responses.stored, ret_value, 'Error on prepending value, unexpected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('prefix_test_data', actual, 'Error on prepending value, value didn`t change accordingly')
    end

    def test_prepend_to_not_existing_item
        memc = Memcached.new()

        ret_value = memc.prepend('test_key', 7, 'prefix_')
        assert_equal(Responses.not_stored, ret_value, 'Error on prepending value, unexpected enum returned')

        actual = memc.storage['test_key']
        assert_nil(actual, 'Error on prepending value, unexisting value was set by prepend method')
    end

    def test_append_to_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 9, 'test_data')

        ret_value = memc.append('test_key', 7, '_posfix')
        assert_equal(Responses.stored, ret_value, 'Error on appending value, unexpected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('test_data_posfix', actual, 'Error on appending value, value didn`t change accordingly')
    end

    def test_append_to_not_existing_item
        memc = Memcached.new()

        ret_value = memc.append('test_key', 7, '_posfix')
        assert_equal(Responses.not_stored, ret_value, 'Error on appending value, unexpected enum returned')

        actual = memc.storage['test_key']
        assert_nil(actual, 'Error on appending value, unexisting value was set by prepend method')
    end

    def test_cas_id_change
        memc = Memcached.new()
        memc.add('test_key', 0, 3600, 9, 'test_data')

        memc.replace('test_key', 0, 3600, 9, 'test_data')
        memc.set('test_key', 0, 3600, 9, 'test_data')
        memc.prepend('test_key', 0, '')
        memc.append('test_key', 0, '')
        memc.cas('test_key', 0, 3600, 9, 4, 'test_data')
        
        actual = memc.storage['test_key'].cas_id

        assert_equal(5, actual, 'Error on cas_id incrementation, unexpected value')
    end

    def test_cas_same_cas_id
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        cas_id = memc.storage['test_key'].cas_id
        ret_value = memc.cas('test_key', 0, 3600, 13, cas_id, 'test_data_new')
        assert_equal(Responses.stored, ret_value, 'Error on cas updating, unexpected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('test_data_new', actual, 'Error on cas updating, new value was not set')
    end

    def test_cas_different_cas_id
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        ret_value = memc.cas('test_key', 0, 3600, 13, 45, 'test_data_new')
        assert_equal(Responses.exists, ret_value, 'Error on cas updating, unespected enum returned')

        actual = memc.storage['test_key'].data
        assert_equal('test_data_old', actual, 'Error on cas updating, old value was change')
    end

    def test_cas_not_existing_item
        memc = Memcached.new()

        ret_value = memc.cas('test_key', 0, 3600, 13, 0, 'test_data')
        assert_equal(Responses.not_found, ret_value, 'Error on cas updating, unespected enum returned')
    end

    def test_delete_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 9, 'test_data')

        ret_value = memc.delete('test_key')
        assert_equal(Responses.deleted, ret_value, 'Error on deleting item, wrong enum returned')

        actual = memc.storage['test_key']
        assert_nil(actual, 'Error on deleting, item wasn`t eliminated')
    end
    
    def test_delete_not_existing_item
        memc = Memcached.new()

        ret_value = memc.delete('test_key')
        assert_equal(Responses.not_found, ret_value, 'Error on deleting item, wrong enum returned')
    end
    
end