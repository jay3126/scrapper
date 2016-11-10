require 'test_helper'

class ScrappersControllerTest < ActionController::TestCase
  setup do
    @scrapper = scrappers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scrappers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scrapper" do
    assert_difference('Scrapper.count') do
      post :create, scrapper: { url: @scrapper.url, user_id: @scrapper.user_id }
    end

    assert_redirected_to scrapper_path(assigns(:scrapper))
  end

  test "should show scrapper" do
    get :show, id: @scrapper
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scrapper
    assert_response :success
  end

  test "should update scrapper" do
    patch :update, id: @scrapper, scrapper: { url: @scrapper.url, user_id: @scrapper.user_id }
    assert_redirected_to scrapper_path(assigns(:scrapper))
  end

  test "should destroy scrapper" do
    assert_difference('Scrapper.count', -1) do
      delete :destroy, id: @scrapper
    end

    assert_redirected_to scrappers_path
  end
end
