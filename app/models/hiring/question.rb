module Hiring
  class Question < ApplicationRecord
    self.table_name = "hiring_questions"

    QUESTION_TYPES = %w[short_text long_text email link file_upload checkbox radio dropdown].freeze
    OPTION_TYPES = %w[checkbox radio dropdown].freeze

    has_many :answers, class_name: "Hiring::Answer", dependent: :destroy

    belongs_to :section, class_name: "Hiring::Section"

    validates :label, presence: true
    validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES }

    def type_icon
      case question_type
      when "short_text" then "type"
      when "long_text" then "align-left"
      when "email" then "mail"
      when "link" then "link"
      when "file_upload" then "upload"
      when "checkbox" then "square-check"
      when "radio" then "circle-dot"
      when "dropdown" then "chevron-down"
      end
    end

    def type_label
      question_type.titleize
    end

    def has_options?
      OPTION_TYPES.include?(question_type)
    end

    def options_list
      return [] if options.blank?
      options.split("\n").map(&:strip).reject(&:blank?)
    end

    def options_list=(value)
      self.options = Array(value).reject(&:blank?).join("\n")
    end
  end
end
