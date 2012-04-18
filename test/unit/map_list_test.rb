require 'test_helper'

class MapListTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert map_lists(:all_map_one).valid?
    assert map_lists(:all_map_two).valid?
    assert map_lists(:all_map_three).valid?
    assert map_lists(:all_map_four).valid?
    assert map_lists(:gm_map_one).valid?
    assert map_lists(:master_map_one).valid?
    assert map_lists(:empty_map_one).valid?
    assert map_lists(:full_map_one).valid?
    assert map_lists(:started_map_one).valid?
  end

  test "map id validations" do
    map_one = map_lists :all_map_one
    map_two = map_lists :all_map_two

    map_one.map_id = nil
    map_two.map_id = Map.all.last.id + 1
    
    assert !map_one.valid?
    assert !map_two.valid?
  end

  test "map order validations" do
    map_one = map_lists :all_map_one
    map_two = map_lists :all_map_two
    map_three = map_lists :all_map_three
    map_four = map_lists :all_map_four

    map_one.map_order = -1
    map_two.map_order = map_three.map_order
    map_four.map_order = map_four.tournament.map_lists.last.map_order + 2
    

    assert !map_one.valid?
    assert !map_two.valid?
    # assert !map_four.valid?
  end

  test "guest accessible attributes" do
    map_list_params = {
      tournament_id: 2,
      map_id: 1,
      map_order: 1
    }

    new_map_list = MapList.new map_list_params, as: :guest

    assert_nil new_map_list.tournament_id
    assert_nil new_map_list.map_id
    assert_nil new_map_list.map_order
  end

  test "member accessible attributes" do
    map_list_params = {
      tournament_id: 2,
      map_id: 1,
      map_order: 1
    }

    new_map_list = MapList.new map_list_params, as: :member

    assert_nil new_map_list.tournament_id
    assert_nil new_map_list.map_id
    assert_nil new_map_list.map_order
  end

  test "moderator accessible attributes" do
    map_list_params = {
      tournament_id: 2,
      map_id: 1,
      map_order: 1
    }

    new_map_list = MapList.new map_list_params, as: :moderator

    assert_nil new_map_list.tournament_id
    assert_equal 1, new_map_list.map_id
    assert_equal 1, new_map_list.map_order
  end

  test "admin accessible attributes" do
    map_list_params = {
      tournament_id: 2,
      map_id: 1,
      map_order: 1
    }

    new_map_list = MapList.new map_list_params, as: :admin

    assert_nil new_map_list.tournament_id
    assert_equal 1, new_map_list.map_id
    assert_equal 1, new_map_list.map_order
  end
end
