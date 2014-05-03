class Camera < ActiveRecord::Base
  belongs_to :manufacturer
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
