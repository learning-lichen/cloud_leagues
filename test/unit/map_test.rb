require 'test_helper'

class MapTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert maps(:shakuras_plateau).valid?
    assert maps(:shattered_temple).valid?
    assert maps(:lost_temple).valid?
  end

  test "name validations" do
    shakuras = maps(:shakuras_plateau)
    shattered = maps(:shattered_temple)
    lost = maps(:lost_temple)

    lost.name = shakuras.name
    shakuras.name = ""
    shattered.name = nil

    assert !lost.valid?
    assert !shakuras.valid?
    assert !shattered.valid?
  end

  test "guest accessible attributes" do
    map_params = { name: 'Hello' }
    new_map = Map.new map_params, as: :guest

    assert_nil new_map.name
  end

  test "member accessible attributes" do
    map_params = { name: 'Hello' }
    new_map = Map.new map_params, as: :member

    assert_nil new_map.name
  end

  test "moderator accessible attributes" do
    map_params = { name: 'Hello' }
    new_map = Map.new map_params, as: :moderator

    assert_nil new_map.name
  end

  test "admin accessible attributes" do
    map_params = { name: 'Hello' }
    new_map = Map.new map_params, as: :admin

    assert_equal 'Hello', new_map.name
  end

  test "strip inputs" do
    lost = maps(:lost_temple)
    lost.name = '      lost        '
    lost.save
    lost.reload

    assert_equal 'lost', lost.name
  end
end
