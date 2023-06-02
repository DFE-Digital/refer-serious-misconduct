class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  has_one_attached :file, dependent: :purge_later
  validates :file, presence: true

  enum section: {
         allegation: "allegation",
         duties: "duties",
         previous_misconduct: "previous_misconduct",
         evidence: "evidence"
       }

  def name
    file.filename.to_s
  end
end
