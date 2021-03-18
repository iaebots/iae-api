# Load the Rails application.
require_relative "application"

require 'carrierwave/orm/activerecord'

# Initialize the Rails application.
Rails.application.initialize!
Rails.configuration.consider_all_requests_local = false
