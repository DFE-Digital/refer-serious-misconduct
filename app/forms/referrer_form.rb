class ReferrerForm
  include ActiveModel::Model

  attr_accessor :referrer
  attr_writer :complete

  validates :complete, inclusion: { in: %w[true false] }
  validates :referrer, presence: true

  def complete
    @complete || referrer&.completed_at? || nil
  end

  def save
    return false unless valid?

    referrer.update(completed_at: complete == "true" ? Time.current : nil)
  end
end
