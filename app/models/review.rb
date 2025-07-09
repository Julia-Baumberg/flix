class Review < ApplicationRecord
  STARS = [1, 2, 3, 4, 5].freeze

  belongs_to :movie
  belongs_to :user
  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: { in: STARS, message: 'must be between 1 and 5' }

  scope :past_n_days, ->(d = 3) { where('created_at > ?', d.days.ago) }

  def stars_as_percent
    (stars / 5.0) * 100.0
  end
end
