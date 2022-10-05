module FeatureFlags
  class Feature < ApplicationRecord
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  end
end
