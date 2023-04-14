require "test_helper"

class JoggingTimesFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user_1)
    @other = users(:user_2)
    @jt = jogging_times(:one)
  end

  test "normal user can CRUD own jogging times" do
    # log in user
    sign_in @user
    # go to home page
    get root_url
    assert_template "static_pages/home"
    # go to jogging times
    get jogging_times_path
    assert_template "jogging_times/index"
    # create jogging time with Ajax
    assert_difference "@user.jogging_times.count", 1 do
      post jogging_times_path, xhr: true, params: {
        jogging_time: {
          distance: '0.5',
          date: '2023-04-03',
          hours: '0',
          minutes: '10',
          seconds: '10' }
        }
    end
    # create jogging time the normal way
    assert_difference "@user.jogging_times.count", 1 do
      post jogging_times_path, params: {
        jogging_time: {
          distance: '0.5',
          date: '2023-04-03',
          hours: '0',
          minutes: '10',
          seconds: '10' }
        }
    end
    assert_redirected_to jogging_times_path
    # go to jogging time edit page
    get edit_jogging_time_path(@jt)
    assert_template "jogging_times/edit"
    # update jogging time
    patch jogging_time_path(@jt), params: {
      jogging_time: {
        distance: '0.5',
        date: '2023-04-03',
        hours: '0',
        minutes: '10',
        seconds: '0' }
      }
    @jt.reload
    assert_equal @jt.duration, 600
    assert_redirected_to jogging_times_path
    follow_redirect!
    # delete jogging time with ajax
    assert_difference '@user.jogging_times.count', -1 do
      delete jogging_time_path(@jt), xhr: true
    end
    # delete jogging time the normal way
    assert_difference '@user.jogging_times.count', -1 do
      delete jogging_time_path(jogging_times(:jt_1))
    end
  end

  test "normal user cannot CRUD other user jogging times" do
    # log in user
    sign_in @other
    # go to jogging times
    get jogging_times_path
    assert_template "jogging_times/index"
    # go to jogging time edit page
    get edit_jogging_time_path(@jt)
    assert_redirected_to jogging_times_path
    follow_redirect!
    # try to update jogging time
    patch jogging_time_path(@jt), params: {
      jogging_time: {
        distance: '0.5',
        date: '2023-04-03',
        hours: '0',
        minutes: '10',
        seconds: '0' }
      }
    assert_redirected_to jogging_times_path
    follow_redirect!
    @jt.reload
    assert_equal @jt.duration, 3600
    # try to delete jogging time with ajax
    assert_no_difference '@user.jogging_times.count' do
      delete jogging_time_path(@jt), xhr: true
    end
    # try to delete jogging time the normal way
    assert_no_difference '@user.jogging_times.count' do
      delete jogging_time_path(jogging_times(:jt_1))
    end
  end

  test "admin user can CRUD any jogging time" do
    # log in admin
    sign_in users(:admin)
    # go to jogging times
    get jogging_times_path
    assert_template "jogging_times/index"
    # go to new jogging time page
    get new_jogging_time_path
    assert_template "jogging_times/new"
    # create jogging time
    assert_difference "@user.jogging_times.count", 1 do
      post jogging_times_path, params: {
        jogging_time: {
          user_id: @user.id,
          distance: '0.5',
          date: '2023-04-03',
          hours: '0',
          minutes: '10',
          seconds: '10' }
        }
    end
    assert_redirected_to jogging_times_path
    # go to jogging time edit page
    get edit_jogging_time_path(@jt)
    assert_template "jogging_times/edit"
    # update jogging time
    patch jogging_time_path(@jt), params: {
      jogging_time: {
        user: @user,
        distance: '0.5',
        date: '2023-04-03',
        hours: '0',
        minutes: '10',
        seconds: '0' }
      }
    @jt.reload
    assert_equal @jt.duration, 600
    assert_redirected_to jogging_times_path
    follow_redirect!
    # delete jogging time with ajax
    assert_difference '@user.jogging_times.count', -1 do
      delete jogging_time_path(@jt), xhr: true
    end
    # delete jogging time the normal way
    assert_difference '@user.jogging_times.count', -1 do
      delete jogging_time_path(jogging_times(:jt_1))
    end
  end

  test "user manager cannot CRUD any jogging time" do
    # log in user manager
    sign_in users(:user_manager)
    # go to jogging times
    get jogging_times_path
    assert_redirected_to root_url
    # go to new jogging time page
    get new_jogging_time_path
    assert_redirected_to root_url
    # create jogging time
    assert_no_difference "@user.jogging_times.count" do
      post jogging_times_path, params: {
        jogging_time: {
          user: @user,
          distance: '0.5',
          date: '2023-04-03',
          hours: '0',
          minutes: '10',
          seconds: '10' }
        }
    end
    assert_redirected_to root_url
    # go to jogging time edit page
    get edit_jogging_time_path(@jt)
    assert_redirected_to root_url
    # update jogging time
    patch jogging_time_path(@jt), params: {
      jogging_time: {
        user_id: @user.id,
        distance: '0.5',
        date: '2023-04-03',
        hours: '0',
        minutes: '10',
        seconds: '0' }
      }
    @jt.reload
    assert_equal @jt.duration, 3600
    assert_redirected_to root_url
    # delete jogging time
    assert_no_difference '@user.jogging_times.count' do
      delete jogging_time_path(jogging_times(:jt_1))
    end
  end

end
