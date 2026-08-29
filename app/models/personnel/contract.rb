module Personnel
  class Contract < ApplicationRecord
    self.table_name = "personnel_contracts"

    has_many :contract_parties, dependent: :destroy, class_name: "Personnel::ContractParty"
    has_many :contract_versions, -> { order(version_number: :desc) }, dependent: :restrict_with_error, class_name: "Personnel::ContractVersion"

    accepts_nested_attributes_for :contract_parties, allow_destroy: true, reject_if: :all_blank

    STATUSES = %w[draft pending active terminated expired]

    include Filterable
    filterable_by :status, label: "Status", options: ->(*) { STATUSES.map { |s| [ s.titleize, s ] } }

    STATUS_BADGE_CLASSES = {
      "draft" => "bg-muted text-muted-foreground",
      "pending" => "bg-warning/15 text-warning",
      "active" => "bg-success/15 text-success",
      "terminated" => "bg-destructive/15 text-destructive",
      "expired" => "bg-secondary text-secondary-foreground"
    }.freeze

    validates :name, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }
    validates :start_date, presence: true
    validate :must_have_at_least_one_party

    def dialog_form_id
      persisted? ? "contract_dialog_form_#{id}" : "contract_dialog_form_new"
    end

    def current_version
      contract_versions.first
    end

    def deletable?
      Configuration.instance.allow_contract_deletion_anytime? || status == "terminated" || status == "expired"
    end

    def status_badge_classes
      STATUS_BADGE_CLASSES.fetch(status, "bg-muted text-muted-foreground")
    end

    private

    def must_have_at_least_one_party
      return if contract_parties.reject(&:marked_for_destruction?).any?

      errors.add(:base, "must have at least one party")
    end
  end
end
