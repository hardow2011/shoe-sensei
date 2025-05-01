module Searchable::Collection  
    extend ActiveSupport::Concern

    included do
        searchkick
    end

    def search_data
        {
            name: name,
            overview_en: overview_en,
            overview_es: overview_es
        }
    end
end
  