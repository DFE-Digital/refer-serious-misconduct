class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true

  has_one_attached :attachment, dependent: :purge_later

  enum section: {
         allegation: "allegation",
         duties: "duties",
         previous_misconduct: "previous_misconduct",
         evidence: "evidence"
       }
end
