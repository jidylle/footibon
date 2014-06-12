require 'test_helper'

class PronosticsControllerTest < ActionController::TestCase
  setup do
    @pronostic = pronostics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pronostics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pronostic" do
    assert_difference('Pronostic.count') do
      post :create, pronostic: { match_id: @pronostic.match_id, score1: @pronostic.score1, score2: @pronostic.score2, user_id: @pronostic.user_id }
    end

    assert_redirected_to pronostic_path(assigns(:pronostic))
  end

  test "should show pronostic" do
    get :show, id: @pronostic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pronostic
    assert_response :success
  end

  test "should update pronostic" do
    put :update, id: @pronostic, pronostic: { match_id: @pronostic.match_id, score1: @pronostic.score1, score2: @pronostic.score2, user_id: @pronostic.user_id }
    assert_redirected_to pronostic_path(assigns(:pronostic))
  end

  test "should destroy pronostic" do
    assert_difference('Pronostic.count', -1) do
      delete :destroy, id: @pronostic
    end

    assert_redirected_to pronostics_path
  end
end
