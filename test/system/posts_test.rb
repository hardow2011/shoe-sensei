require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = Post.first
  end

  test 'list all posts' do
    # TODO: investigate this
    # The sleep is necessary or otherwise, the test would use the admin window
    # for some reason, even after the visit root_url
    sleep 1
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
    # TODO: investigate this
    # The sleep is necessary or otherwise, the test would use the admin window
    # for some reason, even after the visit root_url
    sleep 1
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

  test 'post table of contents' do
    sleep 1
    visit root_url

    within('.navbar') do
      click_on 'Blog'
    end

    click_on 'Read more...', match: :first

    assert_text @post.title
    assert_no_text @post.overview

    header_tags = find_all('.content h2')

    header_tags.each do |tag|
      within('.table-of-contents') do
        assert_selector 'a', text: tag.text
      end
    end
  end
end
