class Document < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  has_attached_file    :file
  validates_attachment :file, presence: true, content_type: { content_type: /\A.*\Z/ }
end
