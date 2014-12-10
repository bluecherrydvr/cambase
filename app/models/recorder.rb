class Recorder < ActiveRecord::Base
  has_many :images, as: :owner
  has_many :documents, as: :owner
  belongs_to :vendor
  before_save :make_slug
  has_paper_trail

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  TYPES = [
    'DVR',
    'NVR',
    'HVR',
    'Encoder',
    'Decoder'
  ]
  FEATURES = ['Onvif', 'PSIA', 'PTZ', 'Support 3rdparty', 'UPnP', 'HDMI', 'Hot Swap', 'Digital IO', 'Discontinued', 'Audio In', 'Audio Out'].freeze

  validates :model, presence: true, :case_sensitive => false, :uniqueness => {:scope => :vendor_id}
  validates :vendor, presence: true
  validates :recorder_type, presence: true

  def make_slug
    self.recorder_slug = self.model
    self.recorder_slug.gsub! ' ', '-'
    self.recorder_slug.gsub!(/[^-0-9A-Za-z_]/, '')
    self.recorder_slug = self.recorder_slug.to_url
  rescue
    puts " -> " + self.model
  end

  def next
    Recorder.where("id > ?", id).order("id ASC").first
  end

  def prev
    Recorder.where("id < ?", id).order("id DESC").first
  end
end
