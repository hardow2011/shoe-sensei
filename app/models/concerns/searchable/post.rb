module Searchable::Post
    extend ActiveSupport::Concern

    included do
        searchkick
    end

    def search_data
        {
            title_en: title_en,
            title_es: title_es,
            content_en: content_en,
            content_en: content_en,
            overview_en: overview_en,
            overview_es: overview_es
        }
    end
end