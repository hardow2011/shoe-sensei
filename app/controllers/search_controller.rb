class SearchController < ApplicationController
    def autocomplete
        # byebug
        results = Searchkick.search(
            search_params, 
            models: [Post, Brand, Collection],
            match: :word_start
            )
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