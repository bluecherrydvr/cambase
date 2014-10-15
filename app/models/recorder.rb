class Recorder < ActiveRecord::Base
  has_many :images, as: :owner
  has_many :documents, as: :owner
  belongs_to :vendor
  before_save :make_slug
  #before_save :titleize_type
  has_paper_trail

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  TYPES = [
    'DVR',
    'NVR',
    'Hybrid DVR'
  ]
  FEATURES = ['Onvif', 'PSIA', 'PTZ', 'Support 3rdparty', 'UPnP', 'Discontinued', 'Audio In', 'Audio Out'].freeze

  validates :model, presence: true, :case_sensitive => false, :uniqueness => {:scope => :vendor_id}
  validates :vendor, presence: true
  validates :recorder_type, presence: true

  def make_slug
    self.recorder_slug = self.model.downcase
  end

  #def titleize_type
  #  self.recorder_type = self.recorder_type.titleize
  #end

  def next
    Recorder.where("id > ?", id).order("id ASC").first
  end

  def prev
    Recorder.where("id < ?", id).order("id DESC").first
  end
end
