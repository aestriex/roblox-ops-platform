module Components::ComboboxHelper
  def render_combobox(items, name:, selected_value: nil, selected_label: nil, placeholder: "Select...")
    render "components/ui/combobox", items:, name:, selected_value:, selected_label:, placeholder:
  end
end
