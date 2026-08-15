class Configuration < ApplicationRecord
  def self.instance
    first_or_create!(org_name: "Studio Proviso")
  end
end
