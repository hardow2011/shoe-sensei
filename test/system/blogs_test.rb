require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
  end

  test 'list all posts' do
    within('.navbar') do
      click_on 'Post'
    end
  end
end
