module Components::DatePickerHelper
  def render_date_picker(name:, id: nil, value: nil, **options)
    iso_value = value.respond_to?(:strftime) ? value.strftime("%Y-%m-%d") : value

    render partial: "components/ui/date_picker", locals: {
      name:,
      value: iso_value,
      id:,
      options: options
    }
  end
end
