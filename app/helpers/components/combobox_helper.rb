module Components::ComboboxHelper
  def render_combobox(items, name:, selected_value: nil, selected_label: nil, placeholder: "Select...", searchable: true)
    render "components/ui/combobox", items:, name:, selected_value:, selected_label:, placeholder:, searchable:
  end
end
