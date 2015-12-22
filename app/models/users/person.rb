class Person < User
  has_many :orders, foreign_key: :user_id
  has_many :deals, through: :orders, foreign_key: :user_id
  belongs_to :complainable, polymorphic: true
  has_many :addresses, foreign_key: :user_id

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
end
