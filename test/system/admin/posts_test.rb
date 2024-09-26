require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
    @new_post = {
      title_en: "The best shoes in the world",
      title_es: "Los mejores zapatos del mundo",
      overview_en: "A short presentation on the best shoes",
      overview_es: "Una corta presentación de los meores zapatos",
      content_en: "The list is the following",
      content_es: "La lista es la siguiente"
    }
  end

  test 'listing all posts' do
    click_on 'Posts'

    posts.each do |p|
      assert_text p.title
    end
  end

  test 'publishing a post' do
    click_on 'Posts'

    assert_text 'Posts', count: 2
    assert_text 'Add a post', count: 2

    click_on 'Add a post', match: :first

    assert_no_text Post.first.title

    assert_text 'New post'

    fill_in "post[title_en]",	with: @new_post[:title_en]
    fill_in "post[title_es]",	with: @new_post[:title_es]
    fill_in "post[overview_en]", with: @new_post[:overview_en]
    fill_in "post[overview_es]", with: @new_post[:overview_es]
    find('.tinymce[name="post[content_en]"]').set(@new_post[:content_en])
    find('.tinymce[name="post[content_es]"]').set(@new_post[:content_es])
    check 'Healthcare'
    check 'Accessories'
    check 'Road running'
    check 'Support'

    assert_button 'Publish Post'
    assert_button 'Save as Draft'
    assert_no_button 'Unpublish and Save as Draft'
    assert_no_button 'Delete Post'
    click_on 'Publish Post'

    assert_text 'Post published successfuly'
    assert_text @new_post[:title_en]

    visit posts_url

    assert_text @new_post[:title_en]
    assert_text @new_post[:overview_en]

    click_on 'Read more...', match: :first

    assert_text @new_post[:title_en]
    assert_no_text @new_post[:overview_en]
    assert_text 'The list is the following'
  end

  test 'saving a post as draft' do
    click_on 'Posts'

    assert_text 'Posts', count: 2
    assert_text 'Add a post', count: 2

    click_on 'Add a post', match: :first

    assert_no_text Post.first.title

    assert_text 'New post'

    fill_in "post[title_en]",	with: @new_post[:title_en]
    fill_in "post[title_es]",	with: @new_post[:title_es]
    fill_in "post[overview_en]", with: @new_post[:overview_en]
    fill_in "post[overview_es]", with: @new_post[:overview_es]
    find('.tinymce[name="post[content_en]"]').set(@new_post[:content_en])
    find('.tinymce[name="post[content_es]"]').set(@new_post[:content_es])
    check 'Healthcare'
    check 'Accessories'
    check 'Road running'
    check 'Support'

    assert_button 'Publish Post'
    assert_button 'Save as Draft'
    assert_no_button 'Delete Post'
    assert_no_button 'Unpublish and Save as Draft'
    click_on 'Save as Draft'

    assert_text 'Post saved as draft successfuly'
    assert_text @new_post[:title_en]

    visit posts_url

    assert_no_text @new_post[:title_en]
    assert_no_text @new_post[:overview_en]
  end

  test 'unpublishing a post' do
    click_on 'Posts'

    click_on 'Edit', match: :first

    assert_text 'Edit post'

    assert_button 'Publish Updates'
    assert_selector 'a', text: 'Delete Post'
    assert_button 'Unpublish and Save as Draft'
    assert_no_selector "input[value='Save as Draft']"
    click_on 'Unpublish and Save as Draft'

    assert_text 'Post saved as draft successfuly'
    assert_text Post.first.title

    visit posts_url

    assert_no_text Post.first.title
    assert_no_text Post.first.overview
  end
end
