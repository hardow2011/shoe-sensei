module DataFormatting
  extend ActiveSupport::Concern

  HANDLE_FORMAT = /[a-zA-Z0-9-]+/

  included do
    def self.get_by_handle(handle)
      self.find_by(handle: handle)
    end
    private
      def assign_handle
        if self.name && self.name_changed?
          self.handle = self.name.parameterize
        end
      end
  end

end
