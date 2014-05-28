class Image < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_attached_file :file, styles: { small: '120x50', medium: '350x350' }
  validates_attachment :file, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }
  validates :file_fingerprint, uniqueness: { :message => "already exists in the database." }

  scope :sorted, -> { order(:position) }

  before_post_process :rename_file

  protected

  def rename_file
    curr = file.instance_read(:file_name)
    succ = "#{SecureRandom.hex}#{File.extname(curr).downcase}"
    file.instance_write(:file_name, succ)
  end
end
