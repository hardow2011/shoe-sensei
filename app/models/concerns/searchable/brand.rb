module Searchable::Brand  
    extend ActiveSupport::Concern

    included do
        searchkick
    end

    def search_data
        {
            name: name
        }
    end
end
  