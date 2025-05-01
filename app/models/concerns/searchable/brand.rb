module Searchable::Brand  
    extend ActiveSupport::Concern

    included do
        searchkick word_start: [:brand]
    end

    def search_data
        {
            name: name
        }
    end
end
  