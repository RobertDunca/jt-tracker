require "test_helper"

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:admin)
    @user_manager = users(:user_manager)
    @user = users(:user_1)
  end

  test "admin user can CRUD any user" do
    # log in admin
    sign_in @admin
    # create new user using AJAX
    get new_user_path
    assert_difference "User.count", 1 do
      post users_path, xhr: true, params: {
        user: {
          username: 'new_user',
          email: 'new_user@example.com',
          password: '123456',
          password_confirmation: '123456',
          role: 'user' }
        }
    end
    # create user the normal way
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          username: 'new_user1',
          email: 'new.user1@example.com',
          password: '123456',
          password_confirmation: '123456',
          role: 'admin'
          }
        }
    end
    assert_redirected_to users_path
    # go to user edit page
    get edit_user_path(@user)
    assert_template "users/edit"
    # update user
    patch user_path(@user), params: {
      user: {
        username: 'new_user10',
        email: 'user_1@example.com',
        role: 'user'
        }
      }
    @user.reload
    assert_equal @user.username, 'new_user10'
    assert_redirected_to users_path
    follow_redirect!
    # delete user with ajax
    assert_difference 'User.count', -1 do
      delete user_path(@user), xhr: true
    end
    # delete user the normal way
    assert_difference 'User.count', -1 do
      delete user_path(users(:user_2))
    end
  end

  test "user manager can CRUD any user" do
    # log in user manager
    sign_in @user_manager
    # create new user using AJAX
    get new_user_path
    assert_difference "User.count", 1 do
      post users_path, xhr: true, params: {
        user: {
          username: 'new_user',
          email: 'new_user@example.com',
          password: '123456',
          password_confirmation: '123456'
          }
        }
    end
    # create user the normal way
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          username: 'new_user1',
          email: 'new.user1@example.com',
          password: '123456',
          password_confirmation: '123456'
          }
        }
    end
    # user_maanger shouldn't be able to provide role for user
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          username: 'new_user1',
          email: 'new.user1@example.com',
          password: '123456',
          password_confirmation: '123456',
          role: 'admin'
          }
        }
    end
    # go to user edit page
    get edit_user_path(@user)
    assert_template "users/edit"
    # update user
    patch user_path(@user), params: {
      user: {
        username: 'new_user10',
        email: 'user_1@example.com'
        }
      }
    @user.reload
    assert_equal @user.username, 'new_user10'
    assert_redirected_to users_path
    follow_redirect!
    # delete user with ajax
    assert_difference 'User.count', -1 do
      delete user_path(@user), xhr: true
    end
    # delete user the normal way
    assert_difference 'User.count', -1 do
      delete user_path(users(:user_2))
    end
  end

end
