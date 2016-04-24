class OrderNotifyJob < ApplicationJob
  queue_as :default

  def perform(order)
    options = { include: [:person, :from_address, :addresses, :transports, :deals] }
    order = ActiveModelSerializers::SerializableResource.new(order, options).as_json

    ActionCable.server.broadcast OrdersNotificationChannel.channel_name, order
  end
end
