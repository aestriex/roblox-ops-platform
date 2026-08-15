module Personnel
  class Person < ApplicationRecord
    self.table_name = "personnel_people"

    belongs_to :user, optional: true

    STATUSES = %w[active on_leave offboarded]
    validates :status, inclusion: { in: STATUSES }
    validates :first_name, :last_name, presence: true

    def full_name
      "#{first_name} #{last_name}"
    end

    def dialog_form_id
      persisted? ? "person_dialog_form_#{id}" : "person_dialog_form_new"
    end
  end
end
