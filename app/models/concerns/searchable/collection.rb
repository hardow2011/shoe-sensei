module Searchable::Collection  
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

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

    def search_name
        "#{brand.name} #{name}"
    end

    def search_description
        I18n.t('collection')
    end

    def search_image
        self.image
    end

    def search_path
        brand_path(self.brand.handle, anchor: self.handle, locale: I18n.locale)
    end

    def search_image
        image = self.models.last&.image || self.brand.logo
        image ? url_for(image) : nil
    end
end
  