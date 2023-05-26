module Uploadable
  extend ActiveSupport::Concern

  included { has_many :uploads, as: :uploadable }
end
