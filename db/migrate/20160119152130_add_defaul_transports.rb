class AddDefaulTransports < ActiveRecord::Migration
  class Transport < ActiveRecord::Base
  end

  def up
    Transport.transaction do
      Transport.delete_all
      ["Пешком", "На велосипеде", "На автомобиле"].each do |name|
        Transport.create(name: name)
      end
    end
  end

  def down
    Transport.delete_all
  end
end
