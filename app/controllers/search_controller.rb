class SearchController < ApplicationController
    def autocomplete
        # "load: false" to get results from search server only, without calling the Database
        posts_search = Post.search(search_params, fields: ["title_#{locale}", "content_#{locale}", "overview_#{locale}"], match: :word_start, load: false)
        brands_search = Brand.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start, load: false)
        collections_search = Collection.search(search_params, fields: [:name, "overview_#{locale}"], match: :word_start, load: false)
        Searchkick.multi_search([posts_search, brands_search, collections_search])

        posts_ids = posts_search.map(&:id)
        brands_ids = brands_search.map(&:id)
        collections_ids = collections_search.map(&:id)

        # Now we call the DB to retrieve the objects, alongside with_attached_logo for brands and .includes(models: :image_attachment) for collections
        # This avoids the N+1 query problem
        posts = Post.where(id: posts_ids)
        # eager load brands logos
        brands = Brand.where(id: brands_ids).with_attached_logo
        # eager load model images from collections
        collections = Collection.where(id: collections_ids).includes(models: :image_attachment)

        responses = collections_search.response['hits']['hits'] + posts_search.response['hits']['hits'] + brands_search.response['hits']['hits']
        results = posts + brands + collections

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