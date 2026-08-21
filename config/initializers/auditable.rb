module AutoAuditable
  EXCLUDED_MODELS = %w[
    ApplicationRecord
    AuditLog
    ActiveStorage::Blob
    ActiveStorage::Attachment
    ActiveStorage::VariantRecord
    ActionText::RichText
    ActionMailbox::InboundEmail
  ].freeze

  def inherited(subclass)
    super
    return if EXCLUDED_MODELS.include?(subclass.name) || subclass.name.nil?

    subclass.include(Auditable)
  end
end

ActiveRecord::Base.singleton_class.prepend(AutoAuditable)
