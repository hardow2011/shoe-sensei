module FilterPagination

  include AllowedTags

  SORTING_OPTIONS = [['Name (A to Z)', :name], ['Cushioning (low to high)', :cushioning_asc], ['Cushioning (high to low)', :cushioning_desc], ['Weight (low to high)', :weight_asc], ['Weight (high to low)', :weight_asc], ['Heel to toe drop (low to high)', :heel_to_toe_drop_asc], ['Heel to toe drop (high to low)', :heel_to_toe_drop_desc]]

  MODELS_PER_PAGE = 9

  def build_page_url(request, page)
    params = request.params
    params[:page] = page
    url_for(params)
  end

  class ModelsFilter
    attr_reader :filter_list, :models, :paged_models, :total_pages, :current_page
    def initialize(selected_activities, selected_cushionings, selected_supports, brands_ids, hide_brand_filter, page)
      selected_activities = selected_activities || []
      selected_cushionings = selected_cushionings || []
      selected_supports = selected_supports || []
      brands_ids = brands_ids || []
      page = page.to_i || 0

      @current_page = page

      @filter_list = {}
      @filter_list[:hide_brand_filter] = hide_brand_filter.to_boolean || false
      @filter_list[:brands] = {}
      @filter_list[:activities] = {}
      @filter_list[:cushionings] = {}
      @filter_list[:supports] = {}

      if brands_ids.any?
        brands_ids = brands_ids.map(&:to_i)
        @models = Model.joins(:brand).where(brand: { id: brands_ids }).order(:name)
        filtered_brands = Brand.all.sort_by(&:name)
      else
        @models = Model.order(:name)
      end

      # Model.where("tags -> 'activities' ?| array[:activities] AND tags -> 'cushioning' ?| array[:cushioning] AND tags -> 'support' ?| array[:support]", activities: ['Road running', 'Training and gym'], cushioning: ['High'], support: ['Neutral'])
      query = ''
      query << "tags -> 'activities' ?| array#{selected_activities.to_s.gsub('"',"'")} "  if selected_activities.any?
      query << "#{query.present? ? ' AND ' : nil } tags -> 'support' ?| array#{selected_supports.to_s.gsub('"',"'")}"  if selected_supports.any?
      query << "#{query.present? ? ' AND ' : nil } tags -> 'cushioning' ?| array#{selected_cushionings.to_s.gsub('"',"'")}"  if selected_cushionings.any?

      if query.present?
        @models = @models.where(query)
      end

      filter_list[:activities] = build_filter(selected_activities, :activities).sort_by { |activity| activity[0] }
      filter_list[:supports] =  build_filter(selected_supports, :support) # this is to sort the support tags
                                  .sort_by { |k, v| AllowedTags::SUPPORT_OPTIONS.find_index(v[:id]) }
      filter_list[:cushionings] = build_filter(selected_cushionings, :cushioning)
                                    .sort_by { |k, v| AllowedTags::CUSHIONING_OPTIONS.find_index(v[:id]) }

      unless @filter_list[:hide_brand_filter]

        unless brands_ids.any?
          filtered_brands = Brand.joins(:models).where(models: { id: @models.map(&:id) }).uniq.sort_by(&:name)
        end

        filtered_brands.each do |brand|
          @filter_list[:brands][brand.name] = { id: brand.id, checked: brands_ids.include?(brand.id) }
        end
      else
        brand = Brand.find_by(id: brands_ids.first)
        @filter_list[:brands][brand.name] = { id: brand.id, checked: brands_ids.include?(brand.id) }
      end

      @models = @models.each_slice(MODELS_PER_PAGE).to_a
      @total_pages = @models.size
      @paged_models = @models[page]
    end

    private

    def build_filter(selected_filter, tags_attr)
      filter_list = {}
      available_filters = (selected_filter + @models.map { |m| m.tags[tags_attr] }.flatten).uniq
      available_filters.each do |a|
        filter_list[a] = { id: a, checked: selected_filter.include?(a) }
      end
      filter_list
    end
  end

  private

  def set_filtered_models(hide_brand_filter, brand_ids = nil)
    brands_ids = params[:brand_ids] || brand_ids
    selected_activities = params[:activities]
    selected_cushionings = params[:cushionings]
    selected_supports = params[:supports]
    hide_brand_filter = params[:hide_brand_filter] || hide_brand_filter
    page = params[:page]

    models_filter = ModelsFilter.new(selected_activities, selected_cushionings, selected_supports, brands_ids, hide_brand_filter, page)
    @filter_list = models_filter.filter_list
    @models = models_filter.models
    @paged_models = models_filter.paged_models
    @total_pages = models_filter.total_pages
    @current_page = models_filter.current_page
  end
end
