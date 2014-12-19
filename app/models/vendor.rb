class Vendor < ActiveRecord::Base
  has_one  :image, as: :owner
  has_many :recorders
  has_many :models
  before_create :make_slug
  has_paper_trail

  accepts_nested_attributes_for :image, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: true

  def make_slug
    self.vendor_slug = self.name.to_url
  end

    def next
      Vendor.where("id > ?", id).order("id ASC").first
    end

    def prev
      Vendor.where("id < ?", id).order("id DESC").first
    end
end
