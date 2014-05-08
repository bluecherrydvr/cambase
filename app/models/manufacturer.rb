class Manufacturer < ActiveRecord::Base
  has_one  :image, as: :owner
  has_many :cameras, dependent: :destroy
  before_save :make_slug

  accepts_nested_attributes_for :image, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true

  def make_slug
    self.manufacturer_slug = self.name.to_url
  end
end
