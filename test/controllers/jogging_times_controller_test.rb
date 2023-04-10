# require 'test_helper'

# class JoggingTimesControllerTest < ActiveSupport::TestCase
#   include Devise::Test::IntegrationHelpers

#   def setup
#     @user = users(:one)
#     @admin = users(:admin)
#     @jogging_time = jogging_times(:one)
#     @params = { jogging_time: { date: '2022-04-10', distance: 10, hours: 1, minutes: 30, seconds: 0 } }
#   end

#   test "should create jogging time when logged in as user" do
#     # set up
#     sign_in @user
#     initial_count = JoggingTime.count

#     # exercise
#     post :create, params: @params

#     # verify
#     assert_equal initial_count + 1, JoggingTime.count
#     assert_redirected_to root_url
#   end

#   test "should not create jogging time when missing parameters" do
#     # set up
#     sign_in @user
#     @params[:jogging_time].delete(:date)
#     initial_count = JoggingTime.count

#     # exercise
#     post :create, params: @params

#     # verify
#     assert_equal initial_count, JoggingTime.count
#     assert_template :index
#   end

#   test "should not create jogging time when not logged in" do
#     # set up
#     initial_count = JoggingTime.count

#     # exercise
#     post :create, params: @params

#     # verify
#     assert_equal initial_count, JoggingTime.count
#     assert_redirected_to new_user_session_url
#   end

#   test "should get edit when logged in as admin" do
#     # set up
#     sign_in @admin

#     # exercise
#     get :edit, params: { id: @jogging_time.id }

#     # verify
#     assert_response :success
#     assert_template :edit
#     assert_select "form[action='#{jogging_time_path(@jogging_time)}']"
#     assert_select "input[name='jogging_time[date]'][type='date']"
#     assert_select "input[name='jogging_time[distance]'][type='number']"
#     assert_select "input[name='jogging_time[hours]'][type='number']"
#     assert_select "input[name='jogging_time[minutes]'][type='number']"
#     assert_select "input[name='jogging_time[seconds]'][type='number']"
#   end

#   test "should redirect edit when logged in as user" do
#     # set up
#     sign_in @user

#     # exercise
#     get :edit, params: { id: @jogging_time.id }

#     # verify
#     assert_redirected_to root_url
#   end

#   test "should update jogging time when logged in as admin" do
#     # set up
#     sign_in @admin
#     params = @params.merge(jogging_time: { distance: 15 })

#     # exercise
#     patch :update, params: { id: @jogging_time.id }.merge(params)

#     # verify
#     assert_equal 15, @jogging_time.reload.distance
#     assert_redirected_to root_url
#   end

#   # test "should not update jogging time when missing parameters" do
#   #   # set up
#   #   sign_in @admin
#   #   params = @params.merge(jogging_time: { distance: nil })

#   #   # exercise
#   #   patch :update, params: { id: @jogging_time.id }.merge(params)

#   #   # verify
#   #   assert_not_equal nil, @jogging_time.reload.distance
# end
