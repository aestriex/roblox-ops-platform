module Components::FilterBarHelper
  def render_filter_bar(model_class, context:, current_params:)
    active_filters = model_class.filterable_fields.filter_map do |field, config|
      value = current_params[field]
      next unless value.present?
      values = config[:options].call(context)
      match = values.find { |_label, v| v.to_s == value.to_s }
      [field, match&.first || value]
    end.to_h

    render "components/ui/filter_bar", model_class: model_class, active_filters: active_filters, current_params: current_params, context: context
  end
end
