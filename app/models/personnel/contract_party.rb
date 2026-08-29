module Personnel
  class ContractParty < ApplicationRecord
    self.table_name = "personnel_contract_parties"

    ENTITY_TYPES = %w[Personnel::Person]

    belongs_to :contract, class_name: "Personnel::Contract"
    belongs_to :entity, polymorphic: true, optional: true

    attr_writer :entity_selector

    before_validation :apply_entity_selector

    validates :entity_type, inclusion: { in: ENTITY_TYPES }, allow_nil: true
    validate :entity_or_custom_name_present

    def entity_selector
      @entity_selector || (entity_type.present? && entity_id.present? ? "#{entity_type}|#{entity_id}" : nil)
    end

    def party_name
      return custom_party_name if entity.blank?

      entity.try(:full_name) || entity.try(:display_name) || entity.try(:name)
    end

    def party_avatar_url
      return entity.display_avatar_url if entity.respond_to?(:display_avatar_url)
      return entity.user.display_avatar_url if entity.respond_to?(:user) && entity.user.present?

      nil
    end

    private

    def apply_entity_selector
      return if @entity_selector.blank?

      type, id = @entity_selector.split("|", 2)
      self.entity_type = type
      self.entity_id = id
    end

    def entity_or_custom_name_present
      return if entity_type.present? && entity_id.present?
      return if custom_party_name.present?

      errors.add(:base, "must be linked to a person or have a custom name")
    end
  end
end
