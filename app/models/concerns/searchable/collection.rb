module Searchable::Collection  
    extend ActiveSupport::Concern

    included do
        searchkick word_start: [:name, :overview_en, :overview_es]
    end

    def search_data
        {
            name: name,
            overview_en: overview_en,
            overview_es: overview_es
        }
    end
end
  