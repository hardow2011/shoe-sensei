require 'application_system_test_case'

class ArticlesTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
  end

  test 'list all articles' do
    within('.navbar') do
      click_on 'Article'
    end
  end
end
