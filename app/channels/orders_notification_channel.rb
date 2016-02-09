class OrdersNotificationChannel < ApplicationCable::Channel
  cattr_accessor(:channel_name) { "order_notifications" }

  def subscribed
    stream_from self.class.channel_name
  end
end
