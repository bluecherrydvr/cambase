class Document < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  has_attached_file    :file
  validates_attachment :file, presence: true, content_type: { content_type: /\A.*\Z/ }
  validates :file_fingerprint, uniqueness: { scope: :owner_id, :message => "already exists in the database." }
end
