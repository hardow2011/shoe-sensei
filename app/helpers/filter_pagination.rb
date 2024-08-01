module FilterPagination
  class ModelsFilter
    attr_reader :filter_list, :models
    def initialize(selected_activities, selected_cushionings, selected_supports, brands_ids)
      selected_activities = selected_activities || []
      selected_cushionings = selected_cushionings || []
      selected_supports = selected_supports || []
      brands_ids = brands_ids || []

      @filter_list = {}
      @filter_list[:brands] = {}
      @filter_list[:activities] = {}
      @filter_list[:cushionings] = {}
      @filter_list[:supports] = {}

      if brands_ids.any?
        brands_ids = brands_ids.map(&:to_i)
        @models = Model.joins(:brand).where(brand: { id: brands_ids })
        filtered_brands = Brand.all
      else
        @models = Model.all
      end

      filter_list[:activities] = build_filter(selected_activities, 'activity_list')
      filter_list[:supports] = build_filter(selected_supports, 'support_list')
      filter_list[:cushionings] = build_filter(selected_cushionings, 'cushioning_list')

      @models = @models.select { |m| m.cached_tags["activity_list"].intersect?(selected_activities) } if selected_activities.any?
      @models = @models.select { |m| m.cached_tags["support_list"].intersect?(selected_supports) } if selected_supports.any?
      @models =  @models.select { |m| m.cached_tags["cushioning_list"].intersect?(selected_cushionings) } if selected_cushionings.any?

      unless brands_ids.any?
        filtered_brands = Brand.joins(:models).where(models: { id: @models.map(&:id) }).uniq
      end

      filtered_brands.each do |brand|
        @filter_list[:brands][brand.name] = { id: brand.id, checked: brands_ids.include?(brand.id) }
      end
    end

    private

    def build_filter(selected_filter, tagging_list)
      filter_list = {}
      available_filters = (selected_filter + @models.map { |m| m.cached_tags[tagging_list] }.flatten).uniq
      available_filters.each do |a|
        filter_list[a] = { id: a, checked: selected_filter.include?(a) }
      end
      filter_list
    end
  end
end
