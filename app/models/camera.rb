class Camera < ActiveRecord::Base
  has_many :images, as: :owner
  has_many :documents, as: :owner
  belongs_to :manufacturer

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  SHAPES = [
    'dome',
    'bullet',
    'box'
  ]
  FEATURES = [:onvif, :psia, :ptz, :infrared, :varifocal, :sd_card, :upnp].freeze

  validates :model, presence: true, :case_sensitive => false, :uniqueness => {:scope => :manufacturer_id}
  validates :manufacturer, presence: true
  validates :shape, inclusion: { in: SHAPES }, :allow_blank => true
end
