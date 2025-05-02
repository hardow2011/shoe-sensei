class SearchController < ApplicationController
    def autocomplete
        posts = Post.search(search_params, fields: ["title_#{locale}", "content_#{locale}", "overview_#{locale}"], match: :word_start)
        brands = Brand.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start)
        collections = Collection.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start)
        Searchkick.multi_search([posts, brands, collections])

        responses = collections.response['hits']['hits'] + posts.response['hits']['hits'] + brands.response['hits']['hits']
        results = posts.to_a + brands.to_a + collections.to_a

        # The sort matches the id and class.name as substring and sorts by score
        results.sort_by! { |result| - responses.find { |response| match_result_response(result, response) }['_score'] }

        results = results.map do |r|
            { name: r.search_name, description: r.search_description, path: r.search_path, image: r.search_image || ActionController::Base.helpers.asset_path('logo/official.webp') }
        end

        render json: results
    end

    private

    def search_params
        params.require(:query)
    end

    def match_result_response(result, response)
        (response['_id'] == result.id.to_s) and (response['_index'].include?(result.class.name.downcase))
    end
end