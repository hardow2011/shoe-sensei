class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  before_action do
    @meta_tags = {
      title: 'SoleFacts Admin'
    }
  end
end
