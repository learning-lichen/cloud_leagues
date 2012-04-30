require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index

    assert_response :success
  end

  test "should get new" do
    login :admin_user
    get :new

    assert_response :success
  end

  test "should not get new" do
    login :default_user
    get :new

    assert_redirected_to root_path
  end

  test "should create map" do
    login :admin_user
    
    name = 'Metropolis'
    image_url = 'i_url'

    assert_difference 'Map.count' do
      post :create, map: { name: name,
        image_url: image_url
      }
    end
    assert_not_nil map = Map.find_by_name(name)
    assert_redirected_to map_path(map)
  end

  test "should now create map" do
    login :default_user
    
    name = 'Metropolis'
    download_url = 'd_url'
    image_url = 'i_url'

    assert_difference 'Map.count', 0 do
      post :create, map: { name: name,
        image_url: image_url
      }
    end
    assert_nil map = Map.find_by_name(name)
    assert_redirected_to root_path
  end

  test "should get edit" do
    login :admin_user
    get :edit, id: maps(:lost_temple).id

    assert_response :success
  end

  test "should update map" do
    login :admin_user
    map = maps(:lost_temple)
    old_name = map.name

    put :update, id: map.id, map: { name: 'New Name' }
    map.reload

    assert_redirected_to map_path(map)
    assert_not_equal old_name, map.name
  end

  test "should not update map" do
    login :default_user
    map = maps(:lost_temple)
    old_name = map.name

    put :update, id: map.id, map: { name: 'New Name' }
    map.reload

    assert_redirected_to root_path
    assert_equal old_name, map.name
  end

  test "should delete map" do
    login :admin_user
    map = maps(:lost_temple)
    delete :destroy, id: map.id

    assert_nil Map.find_by_id(map.id)
    assert_redirected_to maps_path
  end

  test "should not delete map" do
    login :moderator_user
    map = maps(:lost_temple)
    delete :destroy, id: map.id

    assert_not_nil Map.find_by_id(map.id)
    assert_redirected_to root_path
  end

  test "should not delete map in use" do
    login :admin_user
    map = maps :shakuras_plateau
    delete :destroy, id: map.id

    assert_not_nil Map.find_by_id map.id
    assert_redirected_to map_path(@map)
  end
end
