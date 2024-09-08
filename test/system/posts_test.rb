require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = Post.first
  end

  test 'list all posts' do
    within('.navbar') do
      click_on 'Blog'
    end

    assert_text 'Blog'

    Post.first(3).each do |p|
      assert_text p.title
      assert_text p.overview
      assert_no_text @post.content
    end
  end

  test 'show post page' do
    click_on @post.title

    assert_text @post.title
    assert_text @post.content
  end
end
