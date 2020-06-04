require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
  
  test "feed should have the right posts" do
      michael = users(:michael)
      archer  = users(:archer)
      lana    = users(:lana)
      # フォローしているユーザーの投稿を確認
      lana.microposts.each do |post_following|
        assert michael.feed.include?(post_following)
      end
      # 自分自身の投稿を確認
      michael.microposts.each do |post_self|
        assert michael.feed.include?(post_self)
      end
      # フォローしていないユーザーの投稿を確認
      archer.microposts.each do |post_unfollowed|
        assert_not michael.feed.include?(post_unfollowed)
      end
    end
end