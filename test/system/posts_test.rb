require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = Post.first
  end

  test 'list all posts' do
    visit root_url

    within('.navbar') do
      click_on 'Blog'
    end

    assert_text 'Blog'

    Post.first(3).each do |p|
      assert_text p.title
      assert_text p.overview
      # TODO: assert content
      # assert_element p.content.body.to_s
    end
  end

  test 'show post page' do
    visit root_url

    within('.navbar') do
      click_on 'Blog'
    end

    click_on 'Read more...', match: :first

    assert_text @post.title
    assert_no_text @post.overview
    # TODO: assert content
    # assert_element p.content.body.to_s

    @post.tags.each do |tag|
      assert_text I18n.t("filter.#{tag}")
    end
  end
end
