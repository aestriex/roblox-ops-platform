module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filterable_by(attribute, label:, options: nil)
      @filterable_fields ||= {}
      @filterable_fields[attribute.to_s] = { label: label, options: options }
    end

    def filterable_fields
      @filterable_fields || {}
    end

    def apply_filters(filter_params)
      scope = all
      filterable_fields.each_key do |field|
        value = filter_params[field]
        scope = scope.where(field => value) if value.present?
      end
      scope
    end
  end
end
