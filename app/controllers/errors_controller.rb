class ErrorsController < ApplicationController
    def show
        Rails.error.handle(severity: :warning) do
            method = request.method
            path = request.original_url
            raise ActionController::RoutingError.new("No route matches [#{method}] \"/#{path}\"")
        end
        @status_code = params[:code] || 500
    end
end
