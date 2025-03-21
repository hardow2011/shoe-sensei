class ErrorsController < ApplicationController
    def show
        @status_code = params[:code] || 500
    end
end
