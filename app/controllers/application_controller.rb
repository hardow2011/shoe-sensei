class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      admin_home_url
    else
      raise 'Attempted log in s not of type User'
    end
  end
end
