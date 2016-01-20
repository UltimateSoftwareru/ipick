# == Schema Information
#
# Table name: addresses
#
#  id        :integer          not null, primary key
#  name      :string
#  phone     :string
#  user_id   :integer
#  latitude  :float
#  longitude :float
#  address   :string
#

class Address < ActiveRecord::Base
  belongs_to :person, foreign_key: :user_id
  has_and_belongs_to_many :orders

  validates :latitude, :longitude, presence: true

  reverse_geocoded_by :latitude, :longitude, lookup: :yandex
  after_validation :reverse_geocode
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.address = geo.address
    end
  end
  after_validation :reverse_geocode
end
