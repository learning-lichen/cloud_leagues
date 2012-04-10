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

  test "download url validations" do
    shakuras = maps(:shakuras_plateau)
    shattered = maps(:shattered_temple)
    lost = maps(:lost_temple)

    lost.download_url = shakuras.download_url
    shakuras.download_url = ""
    shattered.download_url = nil
    
    assert !lost.valid?
    assert !shakuras.valid?
    assert !shattered.valid?
  end

  test "guest accessible attributes" do
    map_params = { name: 'Hello', image_url: 'i_url', download_url: 'd_url' }
    new_map = Map.new map_params, as: :guest

    assert_nil new_map.name
    assert_nil new_map.download_url
    assert new_map.image_url.blank?
  end

  test "member accessible attributes" do
    map_params = { name: 'Hello', image_url: 'i_url', download_url: 'd_url' }
    new_map = Map.new map_params, as: :member

    assert_nil new_map.name
    assert_nil new_map.download_url
    assert new_map.image_url.blank?
  end

  test "moderator accessible attributes" do
    map_params = { name: 'Hello', image_url: 'i_url', download_url: 'd_url' }
    new_map = Map.new map_params, as: :moderator

    assert_nil new_map.name
    assert_nil new_map.download_url
    assert new_map.image_url.blank?
  end

  test "admin accessible attributes" do
    map_params = { name: 'Hello', image_url: 'i_url', download_url: 'd_url' }
    new_map = Map.new map_params, as: :admin

    assert_equal 'Hello', new_map.name
    assert_equal 'i_url', new_map.image_url
    assert_equal 'd_url', new_map.download_url
  end

  test "strip inputs" do
    lost = maps(:lost_temple)
    lost.name = '      lost        '
    lost.download_url = '       d_url      '
    lost.image_url = '       i_url '
    lost.save
    lost.reload

    assert_equal 'lost', lost.name
    assert_equal 'd_url', lost.download_url
    assert_equal 'i_url', lost.image_url
  end
end
