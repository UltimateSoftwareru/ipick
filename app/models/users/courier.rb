class Courier < ActiveRecord::Base
  include Devisable

  has_many :activities
  belongs_to :transport
  has_many :deals, inverse_of: :courier
  belongs_to :complainable, polymorphic: true

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
end
