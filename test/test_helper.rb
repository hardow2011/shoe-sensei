ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      Searchkick.index_suffix = worker

      # reindex models
      Brand.reindex
      Collection.reindex
      Post.reindex
  
      # and disable callbacks
      Searchkick.disable_callbacks
    end


    # and disable callbacks
    Searchkick.disable_callbacks

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Remove fixture files after tests
    # https://guides.rubyonrails.org/active_storage_overview.html#cleaning-up-fixtures
    parallelize_teardown do |i|
      FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
    end

    def sign_in_as_admin
      user = users(:charo)
      visit new_admin_session_url
  
      fill_in "admin[login]",	with: user.email
      fill_in "admin[password]",	with: 'Ch@ro123'
  
      click_on 'Log In'
    end
  
    def assert_comments(published_comments, deleted_comments, skip_posted_by, skip_posted_under)
      within('.comments') do
        assert_selector 'li.is-active', text: 'Published'
        assert_selector('li:not(.is-active)', text: 'Deleted') if deleted_comments.present?
  
        published_comments.each do |c|
            assert_text ActionController::Base.helpers.strip_tags(c.content)
            assert_text "Posted on: #{I18n.l(c.created_at, format: :long)}"
            assert_text("Posted by: #{c.user.username}") unless skip_posted_by
            if c.parent_comment
                assert_text "Replying to: Comment ##{c.parent_comment.id}"
            end
            assert_text("Posted under: Post ##{c.post.id}") unless skip_posted_under
        end
  
        if deleted_comments.present?
          click_on 'Deleted'
  
          assert_selector 'li:not(.is-active)', text: 'Published'
          assert_selector 'li.is-active', text: 'Deleted'
  
          deleted_comments.each do |c|
              assert_text I18n.t('comment.deleted')
              assert_text "Posted on: #{I18n.l(c.created_at, format: :long)}"
              if c.parent_comment
                  assert_text "Replying to: Comment ##{c.parent_comment.id}"
              end
              assert_text "Under: Post ##{c.post.id}"
          end
        end
      end
    end
  
    # TODO: fix assert_img_src
    def assert_img_src(img)
      # assert_selector :css, "img[src=\"#{url_for(img)}\"]"
    end
    # TODO: fix assert_no_img_src
    def assert_no_img_src(img)
      assert_no_selector :css, "img[src=\"#{url_for(img)}\"]"
    end
  
    def login(username: nil, email: nil, password: nil)
      visit root_url
  
      assert_selector 'a', text: 'Join'
  
      click_on 'Join'
  
      assert_text "Don't have an account yet?"
      assert_no_text "Already have an account?"
  
      fill_in "user[login]", with: username ? username : email
      fill_in "user[password]", with: password
  
      click_on 'Log In'
  
      assert_text 'Logged in successfully.'
  
      assert_no_selector 'a', text: 'Join'
      assert_selector 'a', text: 'Account'
    end

  end
end
