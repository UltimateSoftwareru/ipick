class Address < ActiveRecord::Base
  belongs_to :person, foreign_key: :user_id
  has_and_belongs_to_many :orders

  reverse_geocoded_by :latitude, :longitude, lookup: :yandex
  after_validation :reverse_geocode
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.address = geo.address
    end
  end
  after_validation :reverse_geocode
end
