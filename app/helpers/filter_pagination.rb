module FilterPagination
  include AllowedTags
  class ModelsFilter
    attr_reader :filter_list, :models
    def initialize(selected_activities, selected_cushionings, selected_supports, brands_ids, hide_brand_filter)
      selected_activities = selected_activities || []
      selected_cushionings = selected_cushionings || []
      selected_supports = selected_supports || []
      brands_ids = brands_ids || []

      @filter_list = {}
      @filter_list[:hide_brand_filter] = hide_brand_filter.to_boolean || false
      @filter_list[:brands] = {}
      @filter_list[:activities] = {}
      @filter_list[:cushionings] = {}
      @filter_list[:supports] = {}

      if brands_ids.any?
        brands_ids = brands_ids.map(&:to_i)
        @models = Model.joins(:brand).where(brand: { id: brands_ids })
        filtered_brands = Brand.all.sort_by(&:name)
      else
        @models = Model.all
      end

      filter_list[:activities] = build_filter(selected_activities, :activities).sort_by { |activity| activity[0] }
      filter_list[:supports] =  build_filter(selected_supports, :support) # this is to sort the support tags
                                  .sort_by { |k, v| AllowedTags::SUPPORT_OPTIONS.find_index(v[:id]) }
      filter_list[:cushionings] = build_filter(selected_cushionings, :cushioning)
                                    .sort_by { |k, v| AllowedTags::CUSHIONING_OPTIONS.find_index(v[:id]) }

      @models = @models.select { |m| m.tags[:activities].intersect?(selected_activities) } if selected_activities.any?
      @models = @models.select { |m| selected_supports.include?(m.tags[:support]) } if selected_supports.any?
      @models =  @models.select { |m| selected_cushionings.include?(m.tags[:cushioning]) } if selected_cushionings.any?

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
end
