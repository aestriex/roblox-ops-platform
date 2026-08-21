module Components::DatePickerHelper
  def render_date_picker(name:, id: nil, value: nil, input_html: {}, **options)
    iso_value = value.respond_to?(:strftime) ? value.strftime("%Y-%m-%d") : value

    input_data = { "ui--date-picker-target": "input" }.merge(input_html[:data] || {})
    input_attrs = {
      type: "text",
      value: iso_value,
      autocomplete: "off",
      class: "flex h-9 w-40 rounded-md border border-input bg-background px-2 py-1 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
    }.merge(input_html.except(:data)).merge(data: input_data)

    render partial: "components/ui/date_picker", locals: {
      name:,
      value: iso_value,
      id:,
      input_attrs:,
      options: options
    }
  end
end
