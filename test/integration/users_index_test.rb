require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination',count:2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
  
  test "user search in the case of name_cont blank" do
    log_in_as(@user)
    get users_path, params: {q: {name_cont: ""}}
    User.paginate(page:1).each do |user|
      assert_select 'a[href=?]',user_path(user), text:user.name  
    end
    assert_select 'title', 'All Users | Ruby on Rails Tutorial Sample App'
  end
  
  test "user search in the case of name_cont any" do
    log_in_as(@user)
    get users_path, params: {q: {name_cont: "a"}}
    q = User.ransack(name_cont: "a", activated_true: true)
    q.result.paginate(page:1).each do |user|
      assert_select 'a[href=?]', user_path(user), text:user.name
    end
    assert_select 'title','Search Result | Ruby on Rails Tutorial Sample App'
  end
  
  test "user search no result" do
    log_in_as(@user)
    get users_path, params: {q: {name_cont: "aaaaaaaaaaaaaaaaaaaaaaaa"}}
    assert_match "Couldn't find any user.", response.body
    assert_select 'title', 'Search Result | Ruby on Rails Tutorial Sample App'
  end
end