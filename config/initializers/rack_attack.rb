# frozen_string_literal: true

module Rack
  # Mitigates abusive requests
  class Attack
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    # Requests from localhost will be allowed despite matching any number of blocklists or throttles
    Rack::Attack.safelist_ip('127.0.0.1')

    # Throttle all requests to any route by IP (50rpm/IP)
    throttle('req/ip', limit: 50, period: 1.minute, &:ip)

    # Throttle requests by Authorization header. 100 requests/day per client
    throttle('api/v1/ip', limit: 100, period: 1.day) do |req|
      req.env['HTTP_AUTHORIZATION'].presence
    end

    # Throttle POST requests by Authorization header
    # Maximum 5 POST requests every minute on any POST route
    throttle('api/v1/posts/ip', limit: 5, period: 1.minute) do |req|
      req.env['HTTP_AUTHORIZATION'] if req.env['HTTP_AUTHORIZATION'].presence && req.post?
    end

    # Ban IP for 3 hours if clients makes more than 10 unauthorized requests in 5 minutes
    Rack::Attack.blocklist('block too many unauthorized requests') do |req|
      Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 10, findtime: 5.minutes, bantime: 3.hours) do
        !req.env['HTTP_AUTHORIZATION'].presence
      end
    end
  end
end
