class UserControler < ApplicationController
    before_action :authenticate_user!
end