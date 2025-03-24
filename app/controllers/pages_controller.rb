class PagesController < ApplicationController
  include FilterPagination

  def home
    @models_count = Model.only_still_in_production.count
  end

  def filter_models
    set_filtered_models(nil, params[:brand_id] || nil)
  end

  def privacy_policy
    @meta_tags[:title] = 'Shoe Sensei | ' + I18n.t('policies.privacy.long')
    render "pages/policies/privacy_#{locale}"
  end

  def terms_of_use
    @meta_tags[:title] = 'Shoe Sensei | ' + I18n.t('policies.terms.long')
    render "pages/policies/terms_#{locale}"
  end
end
