class Camera < ActiveRecord::Base
  belongs_to :manufacturer
  SHAPES = [
    'dome',
    'bullet',
    'box'
  ]
  validates :model, presence: true, uniqueness: true
  validates :manufacturer, presence: true
  validates :shape, presence: true, inclusion: { in: SHAPES }
end
