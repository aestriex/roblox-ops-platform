module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filterable_by(attribute, label:, options: nil, scope: nil)
      @filterable_fields ||= {}
      @filterable_fields[attribute.to_s] = { label: label, options: options, scope: scope }
    end

    def filterable_fields
      @filterable_fields || {}
    end

    def apply_filters(filter_params)
      scope = all
      filterable_fields.each do |field, config|
        value = filter_params[field]
        next unless value.present?
        scope = config[:scope] ? config[:scope].call(scope, value) : scope.where(field => value)
      end
      scope
    end
  end
end
