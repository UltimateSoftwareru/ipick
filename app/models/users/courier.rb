class Courier < User
  has_many :activities, foreign_key: :user_id
  belongs_to :transport
  has_many :deals, foreign_key: :user_id
  belongs_to :complainable, polymorphic: true
  has_many :orders, through: :deals, foreign_key: :user_id

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
end
