class Model < ActiveRecord::Base
  has_many :images, as: :owner
  has_many :documents, as: :owner
  belongs_to :vendor
  before_save :make_slug
  before_save :titleize_shape
  has_paper_trail

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  SHAPES = [
    'dome',
    'bullet',
    'box'
  ]
  FEATURES = ['Onvif', 'PSIA', 'PTZ', 'Infrared', 'Varifocal', 'SD Card', 'UPnP', 'Discontinued', 'Audio In', 'Audio Out', 'PoE', 'WiFi'].freeze

  validates :model, presence: true, :case_sensitive => false, :uniqueness => {:scope => :vendor_id}
  validates :vendor, presence: true
  validates :shape, presence: true

  rails_admin do
    edit do
      include_all_fields
      field :additional_information, :text do
        formatted_value do
          value.to_s.gsub('{', '').gsub('}', '')
        end
      end
    end
  end

  def make_slug
    self.model_slug = self.model.to_url
  end

  def titleize_shape
    self.shape = self.shape.titleize
  end

  def next
    Model.where("id > ?", id).order("id ASC").first
  end

  def prev
    Model.where("id < ?", id).order("id DESC").first
  end
end
