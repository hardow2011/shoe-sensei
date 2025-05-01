class SearchController < ApplicationController
    def autocomplete
        results = Searchkick.search(
            search_params, 
            models: [Post, Brand]
            )
        results = results.map do |r|
            { name: r.search_name, description: r.search_description, path: r.search_path }
        end
        
        render json: results
    end

    private

    def search_params
        params.require(:query)
    end
end