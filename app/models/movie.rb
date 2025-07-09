# frozen_string_literal: true

class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17]

  before_save :set_slug

  validates :title, :released_on, :duration, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be a JPG or PNG image'
  }
  validates :rating, inclusion: { in: RATINGS }
  validate :image_file

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  scope :released, -> { where('released_on < ?', Time.now).order('released_on desc') }
  scope :upcoming, -> { where('released_on > ?', Time.now).order('released_on asc') }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { where('total_gross > 300000000').order('total_gross desc') }
  scope :flops, -> { where('total_gross < 250000000').order('total_gross asc') }
  scope :recently_added, -> { order('created_at desc').limit(3) }
  scope :swablu, -> { released.where('total_gross > 400000000') }
  scope :grossed_less_than, ->(amount = 25_000_000) { where('total_gross > ?', amount) }
  scope :grossed_greater_than, ->(amount = 500_000_000) { where('total_gross < ?', amount) }

  def flop?
    return false if reviews.count > 50 && reviews.average(:stars) >= 4.0

    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end

  def to_param
    slug
  end

  # class << self
  #   # def released
  #   #   where('released_on < ?', Time.now).order('released_on desc')
  #   # end

  #   # def hits
  #   #   where('total_gross > 300000000').order('total_gross desc')
  #   # end

  #   # def flops
  #   #   where('total_gross < 250000000').order('total_gross asc')
  #   # end

  #   # def recently_added
  #   #   order('created_at desc').limit(3)
  #   # end
  # end

  private

  def image_file
    return unless image_file_name.present?

    path = Rails.root.join('app', 'assets', 'images', image_file_name)

    return if File.exist?(path)

    self.image_file_name = 'placeholder.png'
  end

  def set_slug
    self.slug = title.parameterize
  end
end
