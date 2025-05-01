module Searchable::Post
    extend ActiveSupport::Concern

    included do
        searchkick word_start: [:title_en, :title_es, :content_en, :content_es, :overview_en, :overview_es]
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