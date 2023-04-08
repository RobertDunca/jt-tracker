require "test_helper"

class JoggingTimesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # to authenticate the user

  def setup
    @user = users(:one)
    @jogging_time = jogging_times(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'JoggingTime.count' do
      post jogging_times_path, params: { jogging_time: { date: Time.zone.today, distance: 5, hours: 0, minutes: 30, seconds: 0 } }
    end
    assert_redirected_to new_user_session_path
  end

  test "should create jogging_time when logged in" do
    sign_in @user
    assert_difference 'JoggingTime.count', 1 do
      post jogging_times_path, params: { jogging_time: { date: Time.zone.today, distance: 5, hours: 0, minutes: 30, seconds: 0 } }
    end
    assert_redirected_to root_path
  end

  test "should render index when create fails" do
    sign_in @user
    assert_no_difference 'JoggingTime.count' do
      post jogging_times_path, params: { jogging_time: { date: Time.zone.today, distance: -1, hours: 0, minutes: 30, seconds: 0 } }
    end
    assert_template :index
    assert_select 'div#error_explanation'
  end

  test "should redirect edit when not logged in" do
    get edit_jogging_time_path(@jogging_time)
    assert_redirected_to new_user_session_path
  end

  test "should render edit when logged in" do
    sign_in @user
    get edit_jogging_time_path(@jogging_time)
    assert_template :edit
  end

  test "should redirect update when not logged in" do
    patch jogging_time_path(@jogging_time), params: { jogging_time: { distance: 10 } }
    assert_redirected_to new_user_session_path
  end

  # test "should update jogging_time when logged in" do
  #   sign_in @user
  #   patch jogging_time_path(@jogging_time), params: { jogging_time: { distance: 10 } }
  #   assert_redirected_to root_path
  #   @jogging_time.reload
  #   assert_equal 10, @jogging_time.distance
  # end

  test "should render edit when update fails" do
    sign_in @user
    patch jogging_time_path(@jogging_time), params: { jogging_time: { distance: -1 } }
    assert_template :edit
    assert_select 'div#error_explanation'
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'JoggingTime.count' do
      delete jogging_time_path(@jogging_time)
    end
    assert_redirected_to new_user_session_path
  end

  test "should destroy jogging_time when logged in" do
    sign_in @user
    assert_difference 'JoggingTime.count', -1 do
      delete jogging_time_path(@jogging_time)
    end
    assert_redirected_to root_path
  end
end
