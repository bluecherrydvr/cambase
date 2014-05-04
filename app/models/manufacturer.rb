class Manufacturer < ActiveRecord::Base
  has_one  :image, as: :owner
  has_many :cameras, dependent: :destroy

  accepts_nested_attributes_for :image, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true
end
