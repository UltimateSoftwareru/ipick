# This file is used by Rack-based servers to start the application.

require ::File.expand_path('./../../config/environment', __FILE__)
run Rails.application

require 'action_cable/process/logging'
client_host = Rails.application.config_for(:client).fetch("host")
ActionCable.server.config.allowed_request_origins = [client_host]
run ActionCable.server
