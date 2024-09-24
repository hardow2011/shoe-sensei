# TODO: optimize this whole module.
# DRY in the views.
# Queries too slow/numerous
# TODO: check that params are valid before processing them
module FilterPagination
  include AllowedTags

  SORTING_OPTIONS = [['Name (A to Z)', :name], ['Cushioning (low to high)', :cushioning_asc], ['Cushioning (high to low)', :cushioning_desc], ['Weight (low to high)', :weight_asc], ['Weight (high to low)', :weight_desc], ['Heel to toe drop (low to high)', :heel_to_toe_drop_asc], ['Heel to toe drop (high to low)', :heel_to_toe_drop_desc]]
  ALLOWED_ADDITIONAL_FILTERS = [:apma_accepted, :show_discontinued]

  MODELS_PER_PAGE = 9

  def build_page_url(request, page)
    params = request.params
    params[:page] = page
    url_for(params)
  end

  class ModelsFilter
    attr_reader :filter_list, :models, :paged_models, :total_pages, :current_page, :selected_sort, :single_brand_id
    def initialize(selected_activities, selected_cushionings, selected_supports, selected_aditional_filters,
                    brands_ids, single_brand_id, page, sort)
      selected_activities = selected_activities || []
      selected_cushionings = selected_cushionings&.map(&:to_i) || []
      selected_supports = selected_supports || []
      brands_ids = brands_ids&.map(&:to_i) || []
      selected_aditional_filters = selected_aditional_filters || []
      page = page.to_i || 0
      sort = sort&.to_sym || SORTING_OPTIONS.first[1]

      @invalid = false

      fobidden_tags = Rails.error.handle(severity: :warning, fallback: -> {true}) do
        error_message = ""
        forbidden_activities = selected_activities - AllowedTags::ACTIVITY_OPTIONS
        if forbidden_activities.any?
          error_message << "#{forbidden_activities} not allowed activities tags. "
          selected_activities = selected_activities & AllowedTags::ACTIVITY_OPTIONS
        end

        forbidden_cushionings = selected_cushionings - [*1..AllowedTags::CUSHIONING_OPTIONS.size]
        if forbidden_cushionings.any?
          error_message << "#{forbidden_cushionings} not allowed cushionings tags. "
          selected_cushionings = selected_cushionings & [*1..AllowedTags::CUSHIONING_OPTIONS.size]
        end

        forbidden_supports = selected_supports - AllowedTags::SUPPORT_OPTIONS
        if forbidden_supports.any?
          error_message << "#{forbidden_supports} not allowed supports tags"
          selected_supports = selected_supports & AllowedTags::SUPPORT_OPTIONS
        end

        forbidden_additionals = selected_aditional_filters - AllowedTags::ADDITIONAL_OPTIONS
        if forbidden_additionals.any?
          error_message << "#{forbidden_additionals} not allowed additional tags."
          selected_aditional_filters = selected_aditional_filters & AllowedTags::ADDITIONAL_OPTIONS
        end
        raises error_message if error_message.present?
      end

      if fobidden_tags
        @invalid = true
      end

      selected_aditional_filters = selected_aditional_filters&.map(&:to_sym)

      @current_page = page

      @filter_list = {}
      @filter_list[:brands] = {}
      @filter_list[:activities] = {}
      @filter_list[:cushionings] = {}
      @filter_list[:supports] = {}
      @filter_list[:additional_filters] = []
      @filter_list[:single_brand_id] = single_brand_id&.to_i || nil

      show_discontinued_models = selected_aditional_filters.exclude?(:show_discontinued)

      # Filter models based on selected filters (excluding brands)
      models_pre_brand_filter = Model.only_still_in_production(show_discontinued_models)

      if brands_ids.any? or single_brand_id
        models_to_filter = models_pre_brand_filter.filter_by_brand_ids(single_brand_id.present? ? [single_brand_id] : brands_ids )
      else
        models_to_filter = models_pre_brand_filter
      end

      # TODO: make the filters building async

      # Create filter list for activities
      @filter_list[:activities] = build_filter(models_to_filter, selected_activities, AllowedTags::ACTIVITY_OPTIONS,
      'filter_by_activities', :activities).sort_by { |activity| activity[0] }

      models_to_filter = models_to_filter.filter_by_activities(selected_activities)

      # Create filter list for supports
      @filter_list[:supports] =  build_filter(models_to_filter, selected_supports,
                                              AllowedTags::SUPPORT_OPTIONS, 'filter_by_supports', :support)
                                              # this is to sort the support tags
                                              .sort_by { |k, v| AllowedTags::SUPPORT_OPTIONS.find_index(v[:id]) }

      models_to_filter = models_to_filter.filter_by_supports(selected_supports)

      # Create filter list for cushionings
      @filter_list[:cushionings] = build_filter(models_to_filter, selected_cushionings,
                                                [*1..AllowedTags::CUSHIONING_OPTIONS.size], 'filter_by_cushioning_levels',
                                                :cushioning_level)
                                                .sort_by { |k, _| k }
                                                .map { |a, b| [ AllowedTags::CUSHIONING_OPTIONS[a.to_i - 1], b ] }

      models_to_filter = models_to_filter.filter_by_cushioning_levels(selected_cushionings)
                      .filter_by_apma_accepted(selected_aditional_filters.include?(:apma_accepted))

      # Filter models based on selected brands
      @models = models_to_filter.filter_by_brand_ids(single_brand_id.present? ? [single_brand_id] : brands_ids )

      # Get all brands from filtered models
      filtered_brands = Brand.joins(:models).where(models: { id: (brands_ids.any? ? models_pre_brand_filter : (@models & models_pre_brand_filter)).map(&:id) }).uniq.sort_by(&:name)

      # Create filter list for brands
      filtered_brands.each do |brand|
        @filter_list[:brands][brand.name] = { id: brand.id, checked: brands_ids.include?(brand.id) }
      end

      # Create filter list for additional filters
      ALLOWED_ADDITIONAL_FILTERS.each do |filter|
        @filter_list[:additional_filters] << { name: filter, checked: selected_aditional_filters.include?(filter) }
      end

      # Sort filtered models
      case sort
      when :name
        @models = @models.order(:name)
      when :cushioning_asc
        @models = @models.order_by_cushioning_level
      when :cushioning_desc
        @models = @models.order_by_cushioning_level(:desc)
      when :weight_asc
        @models = @models.order_by_weight
      when :weight_desc
        @models = @models.order_by_weight(:desc)
      when :heel_to_toe_drop_asc
        @models = @models.order_by_heel_to_toe_drop
      when :heel_to_toe_drop_desc
        @models = @models.order_by_heel_to_toe_drop(:desc)
      end

      @models = @models.each_slice(MODELS_PER_PAGE).to_a
      @total_pages = @models.size
      @paged_models = @models[page]
      @selected_sort = SORTING_OPTIONS.select { |o| o[1] == sort }.first
    end

    def invalid?
      @invalid
    end

    private

    # This filter makes sure that the remaining avilable filters have at least one model
    def build_filter(models, selected_filter, filter_options, filter_method, tags_attr)
      filter_list = {}
      available_filters = []

      filter_options.each do |a|
        models.send(filter_method, [a]).any? ? available_filters << a : nil
      end

      available_filters.each do |a|
        filter_list[a] = { id: a, checked: selected_filter.include?(a) }
      end
      filter_list
    end
  end

  private

  def set_filtered_models(brand_ids, single_brand_id)
    brands_ids = params[:brand_ids] || brand_ids
    selected_activities = params[:activities]
    selected_cushionings = params[:cushionings]
    selected_supports = params[:supports]
    page = params[:page]
    sort = params[:models_sorting]
    selected_aditional_filters = params[:additional_filters]
    single_brand_id = params[:single_brand_id] || single_brand_id

    models_filter = ModelsFilter.new(selected_activities, selected_cushionings, selected_supports,
                                      selected_aditional_filters, brands_ids, single_brand_id, page, sort)

    @filter_list = models_filter.filter_list
    @models = models_filter.models
    @paged_models = models_filter.paged_models
    @total_pages = models_filter.total_pages
    @current_page = models_filter.current_page
    @selected_sort = models_filter.selected_sort

    if models_filter.invalid?
      flash.now[:notice] = I18n.t('invalid_filter_tags')
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
