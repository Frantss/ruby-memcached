require_relative '../Memcached.rb'
require_relative '../Responses.rb'
require_relative '../Item.rb'
require 'test/unit'

class TestCommands < Test::Unit::TestCase


    def test_set_setting_item
        memc = Memcached.new()
        ret_value = memc.set('test_key', 0, 3600, 4, 'test_data')
        assert_equal(Responses.stored, ret_value, 'Error on adding value, unexpected enum returned')
        assert_not_nil(memc.storage['test_key'], 'Error on adding value, value not added')
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
        assert_not_nil(memc.storage['test_key'], 'Error on adding value, value not added')
    end

    def test_add_adding_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        ret_value = memc.add('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.not_stored, ret_value, 'Error on adding value, unexpected enum returned')

        actual = memc.get('test_key').data
        assert_equal('test_data_old', actual, 'Error on adding value, value changed') if ret_value != Responses.stored
        assert_not_equal('test_data_new', actual, 'Error on adding value, value changed')
    end

    def test_replace_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 13, 'test_data_old')

        ret_value = memc.replace('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.stored, ret_value, 'Error on replacing value, unexpected enum returned')

        actual = memc.get('test_key').data
        assert_equal('test_data_new', actual, 'Error on replacing value, value didn`t changed')
    end

    def test_replace_not_existing_item
        memc = Memcached.new()

        ret_value = memc.replace('test_key', 0, 3600, 13, 'test_data_new')
        assert_equal(Responses.not_stored, ret_value, 'Error on replacing value, unexpected enum returned')

        assert_nil(memc.get('test_key'), 'Error on replacing value, unexisting value was set by replace method')
    end

    def test_prepend_to_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 9, 'test_data')

        ret_value = memc.prepend('test_key', 7, 'prefix_')
        assert_equal(Responses.stored, ret_value, 'Error on prepending value, unexpected enum returned')

        actual = memc.get('test_key').data
        assert_equal('prefix_test_data', actual, 'Error on prepending value, value didn`t change accordingly')
    end

    def test_prepend_to_not_existing_item
        memc = Memcached.new()

        ret_value = memc.prepend('test_key', 7, 'prefix_')
        assert_equal(Responses.not_stored, ret_value, 'Error on prepending value, unexpected enum returned')

        assert_nil(memc.get('test_key'), 'Error on prepending value, unexisting value was set by prepend method')
    end

    def test_append_to_existing_item
        memc = Memcached.new()
        memc.set('test_key', 0, 3600, 9, 'test_data')

        ret_value = memc.append('test_key', 7, '_posfix')
        assert_equal(Responses.stored, ret_value, 'Error on appending value, unexpected enum returned')

        actual = memc.get('test_key').data
        assert_equal('test_data_posfix', actual, 'Error on appending value, value didn`t change accordingly')
    end

    def test_append_to_not_existing_item
        memc = Memcached.new()

        ret_value = memc.append('test_key', 7, '_posfix')
        assert_equal(Responses.not_stored, ret_value, 'Error on appending value, unexpected enum returned')

        assert_nil(memc.get('test_key'), 'Error on appending value, unexisting value was set by prepend method')
    end
end