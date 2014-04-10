class Manufacturer < ActiveRecord::Base
  has_many :cameras, dependent: :destroy 
end
