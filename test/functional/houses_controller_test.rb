require 'test_helper'

class HousesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:houses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create house" do
    assert_difference('House.count') do
      post :create, :house => { }
    end

    assert_redirected_to house_path(assigns(:house))
  end

  test "should show house" do
    get :show, :id => houses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => houses(:one).to_param
    assert_response :success
  end

  test "should update house" do
    put :update, :id => houses(:one).to_param, :house => { }
    assert_redirected_to house_path(assigns(:house))
  end

  test "should destroy house" do
    assert_difference('House.count', -1) do
      delete :destroy, :id => houses(:one).to_param
    end

    assert_redirected_to houses_path
  end
end
