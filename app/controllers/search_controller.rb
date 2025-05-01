class SearchController < ApplicationController
    def autocomplete
        posts = Post.search(search_params, fields: ["title_#{locale}", "content_#{locale}", "overview_#{locale}"], match: :word_start)
        brands = Brand.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start)
        collections = Collection.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start)
        results = posts.to_a + brands.to_a + collections.to_a
        results = results.map do |r|
            { name: r.search_name, description: r.search_description, path: r.search_path, image: r.search_image }
        end
        render json: results
    end

    private

    def search_params
        params.require(:query)
    end
end