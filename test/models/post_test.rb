require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @valid_post = Post.new(title_en: 'The best looking shoes', title_es: 'Los zapatos más bonitos',
      overview_en: 'We talk about the prettiest shoes', overview_es: 'hablamos de los zapatos más bonitos',
      content_en: '<h2>Introduction</h2><h2>History of Shoes</h2><h3>Early Years</h3><h3>Industrial Development</h3><h4>Other Occurrences</h4><h2>Rise and Fall</h2><h4>Sources</h4><h5>Further Reading</h5>',
      content_es: '<h2>Introducción</h2><h2>Historia de los zapatos</h2><h3>Primeros Años</h3><h3>Desarrollo Industrial</h3><h4>Otros acontecimientos</h4><h2>Surgimiento y Caída</h2><h4>Fuentes</h4><h5>Leer Más</h5>',
      tags: ['road_running', 'walking', 'cost_conscious', 'support'],
      published_at: Date.parse("Jan 15 2022"),
      published: true)
  end
  test "valid post" do
    post = @valid_post
    post.save
    assert post.valid?
  end

  test 'invalid without English title' do
    post = @valid_post
    post.title_en = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:title_en], 'no validation for English title present'
  end

  test 'invalid without Spanish title' do
    post = @valid_post
    post.title_es = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:title_es], 'no validation for Spanish title present'
  end

  test 'invalid without English overview' do
    post = @valid_post
    post.overview_en = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:overview_en], 'no validation for English overview present'
  end

  test 'invalid without Spanish overview' do
    post = @valid_post
    post.overview_es = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:overview_es], 'no validation for Spanish overview present'
  end

  test 'invalid without English content' do
    post = @valid_post
    post.content_en = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:content_en], 'no validation for English content present'
  end

  test 'invalid without Spanish content' do
    post = @valid_post
    post.content_es = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:content_es], 'no validation for Spanish content present'
  end

  test 'invalid without published' do
    post = @valid_post
    post.published = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:published], 'no validation for published'
  end

  test 'invalid without published_at' do
    post = @valid_post
    post.published_at = nil
    post.save
    refute post.valid?
    assert_not_empty post.errors[:published_at], 'no validation for published_at'
  end

  test 'correct title parameterization to handle' do
    post = @valid_post
    post.save
    assert post.valid?
    assert_equal 'the-best-looking-shoes', post.handle, 'handle malformed'
  end

  test 'correct handle cut-off' do
    post = @valid_post
    post.title_en = "I went to the store to get some nw shoes, but they ran out of the models I wanted. So I went home sad"
    post.save
    assert post.valid?
    assert_equal 'i-went-to-the-store-to-get-some-nw-shoes-but-they', post.handle, 'handle malformed'

    new_post = @valid_post
    new_post.title_en = "I went to the store to get some nw shoes, but they ran out of the models I wanted. So I went home sad Pt.2"
    new_post.title_es = "No importa"
    new_post.save
    assert new_post.valid?
    assert_equal 'i-went-to-the-store-to-get-some-nw-shoes-but-they-2', new_post.handle, 'handle iteration malformed'
  end

  test 'unique title' do
    @valid_post.save
    post = @valid_post.dup
    post.save
    refute post.valid?, 'post valid with non unique title'
    assert_not_empty post.errors[:title_en], 'no validation for non unique English title'
    assert_not_empty post.errors[:title_es], 'no validation for non unique Spanish title'
  end

  test 'invalid with invalid tags' do
    post = @valid_post.dup
    post.tags = ['road_running', 'ola_k_ase', 'standing', 'something_else']
    post.save
    refute post.valid?
    assert_not_empty post.errors[:tags], 'no validation for tags'
  end

  test 'content sanitized' do
    post = @valid_post.dup
    post.content_en = '<h1>This is important!!!</h1><p>It really is.</p>'
    post.content_es = '<h1>¡¡¡Esto es importante!!!</h1><p>Realmente lo es.</p>'
    post.save
    assert post.valid?

    assert_equal '<h2 id="this-is-important">This is important!!!</h2><p>It really is.</p>', post.content_en.gsub(/\n/, '')
    assert_equal '<h2 id="esto-es-importante">¡¡¡Esto es importante!!!</h2><p>Realmente lo es.</p>', post.content_es.gsub(/\n/, '')
  end

  test 'saving a draft with missing attributes' do
    post = Post.new(published: false)

    post.save
    refute post.valid?

    assert_not_empty post.errors[:title_en]
    assert_not_empty post.errors[:title_es]

    post.title_en = @valid_post.title_en
    post.save
    refute post.valid?

    assert_empty post.errors[:title_en]
    assert_not_empty post.errors[:title_es]

    post.title_es = @valid_post.title_es
    post.save
    assert post.valid?

    assert_empty post.errors[:title_en]
    assert_empty post.errors[:title_es]

    post.published = true
    post.save
    refute post.valid?
  end

  test 'saving two drafts with no handle' do
    post_1 = Post.new(title_en: 'p1_en', title_es: 'p1_en', published: false)
    post_2 = Post.new(title_en: 'p2_en', title_es: 'p2_en', published: false)

    post_1.save
    assert post_1.valid?
    assert_empty post_1.errors[:handle]

    post_2.save
    assert post_2.valid?
    assert_empty post_2.errors[:handle]
  end

  test 'handle assigned after publication' do
    post = @valid_post.dup
    post.published = false
    post.save

    assert post.valid?
    assert_nil post.handle
    assert_empty post.errors[:handle]

    post.published = true
    post.save
    assert_empty post.errors[:handle]
  end

  test 'valid table_of_contents' do
    post = @valid_post.dup
    post.save

    assert post.valid?

    assert_equal [{:tag=>"h2", :title=>"Introduction", :id=>"introduction"}, {:tag=>"h2", :title=>"History of Shoes", :id=>"history-of-shoes", nested_tags: [{:tag=>"h3", :title=>"Early Years", :id=>"early-years"}, {:tag=>"h3", :title=>"Industrial Development", :id=>"industrial-development"}]}, {:tag=>"h2", :title=>"Rise and Fall", :id=>"rise-and-fall"}], post.table_of_contents_en
    assert_equal [{:tag=>"h2", :title=>"Introducción", :id=>"introduccion"}, {:tag=>"h2", :title=>"Historia de los zapatos", :id=>"historia-de-los-zapatos", nested_tags: [{:tag=>"h3", :title=>"Primeros Años", :id=>"primeros-anos"}, {:tag=>"h3", :title=>"Desarrollo Industrial", :id=>"desarrollo-industrial"}]}, {:tag=>"h2", :title=>"Surgimiento y Caída", :id=>"surgimiento-y-caida"}], post.table_of_contents_es
  end
end
