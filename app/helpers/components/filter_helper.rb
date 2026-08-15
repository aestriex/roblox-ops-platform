module Components::FilterHelper
  def filter_icon(&block)
    content_for :filter_icon, capture(&block), flush: true
  end

  def render_filter(items, **options, &block)
    options[:pattern] ||= "^{input}"
    content_for :filter_icon, "", flush: true
    content = capture(&block) if block
    input_class = content_for?(:filter_icon) ? "pl-1" : ""
    render "components/ui/filter", items: items, options: options, input_class: input_class, content: content
  end

  def filter_list_item(value:, name:, selected:, avatar: nil)
    content_tag :div,
      class: "flex items-center gap-2 px-2 py-1.5 text-sm rounded-sm cursor-pointer hover:bg-accent #{"bg-accent" if selected}",
      data: { value: value, action: "click->ui--combobox#select" } do
      safe_join([
        (image_tag(avatar, class: "w-5 h-5 rounded-full") if avatar.present?),
        content_tag(:span, name)
      ].compact)
    end
  end
end
