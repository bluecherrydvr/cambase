class Manufacturer < ActiveRecord::Base
  has_one  :image, as: :owner
  has_many :cameras
  before_create :make_slug
  has_paper_trail

  accepts_nested_attributes_for :image, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true

  def make_slug
    self.manufacturer_slug = self.name.to_url
  end
end
