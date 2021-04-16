class Rack::Attack

    ### Configure Cache ###
  
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 
  
    ### Throttle Spammy Clients ###
  
    # Throttle all requests by IP (60rpm)
    
    # Max 5 requests per minut
    throttle('req/ip', limit: 5, period: 1.minute) do |req|
      req.ip 
    end

    # Max 100 requests per day
    throttle('api/v1/ip', limit: 100, period: 1.day) do |req|
        req.ip 
    end

  
    # Throttle POST requests to /api/v1/posts by IP address
    throttle('api/v1/posts/ip', limit: 1, period: 1.minute) do |req|
        if req.path == '/api/v1/posts' && req.post?
            req.ip
        end
    end
end