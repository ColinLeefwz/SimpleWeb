require 'test_helper'

class ShopNoticesControllerTest < ActionController::TestCase
  setup do
    @shop_notice = shop_notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shop_notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shop_notice" do
    assert_difference('ShopNotice.count') do
      post :create, :shop_notice => @shop_notice.attributes
    end

    assert_redirected_to shop_notice_path(assigns(:shop_notice))
  end

  test "should show shop_notice" do
    get :show, :id => @shop_notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @shop_notice
    assert_response :success
  end

  test "should update shop_notice" do
    put :update, :id => @shop_notice, :shop_notice => @shop_notice.attributes
    assert_redirected_to shop_notice_path(assigns(:shop_notice))
  end

  test "should destroy shop_notice" do
    assert_difference('ShopNotice.count', -1) do
      delete :destroy, :id => @shop_notice
    end

    assert_redirected_to shop_notices_path
  end
end
