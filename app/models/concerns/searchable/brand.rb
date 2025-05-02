module Searchable::Brand  
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    included do
        searchkick word_start: [:name, :overview_en, :overview_es]
    end

    def search_data
        {
            name: name,
            overview_en: overview_en,
            overview_es: overview_es,
        }
    end

    def search_name
        name
    end

    def search_description
        I18n.t('brand')
    end

    def search_path
        brand_path(self.handle, locale: I18n.locale)
    end

    def search_image
        url_for self.logo
    end
end
  