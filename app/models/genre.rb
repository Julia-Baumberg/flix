class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  before_save :set_category
  before_save :set_slug

  def to_param
    slug
  end

  private

  def set_category
    self.category = name
  end

  def set_slug
    self.slug = category.parameterize
  end
end
