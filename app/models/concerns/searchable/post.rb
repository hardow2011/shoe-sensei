module Searchable::Post
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    included do
        searchkick word_start: [:title_en, :title_es, :content_en, :content_es, :overview_en, :overview_es]
    end

    def search_data
        {
            title_en: title_en,
            title_es: title_es,
            content_en: content_en,
            content_es: content_es,
            overview_en: overview_en,
            overview_es: overview_es
        }
    end

    def search_name
        title
    end

    def search_description
        I18n.t('blog_post')
    end

    def search_path
        post_path(self.handle, locale: I18n.locale)
    end

    def search_image
        nil
    end

end