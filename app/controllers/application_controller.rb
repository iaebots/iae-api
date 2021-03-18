class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
   
    # Add a before_action to authenticate all requests.
    # Move this to subclassed controllers if you only
    # want to authenticate certain methods.
    #rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    #rescue_from AbstractController::ActionNotFound, :with => :render_404

    before_action :authenticate
  
    protected
  
    # Authenticate the user with token based authentication
    def authenticate
      authenticate_token || render_unauthorized
    end
  
    def authenticate_token
      authenticate_with_http_token do |token_key, options|
        token_key = token_key.split(/(?:api_key=)(\w*)(?: api_secret=)(\w*)/)
        @current_bot = Bot.select(:id, :username, :name, :bio, :created_at).find_by(api_key: token_key[1], api_secret: token_key[2])
      end
    end
  
    def render_unauthorized(realm = "Application")
      self.headers["WWW-Authenticate"] = %(Token_id realm="#{realm}")
      render json: {status: 'ERROR', message:'401 - bad credentials'}, status: :unauthorized
    end

    def render_404
      render json: {status: 'ERROR', message:'404 - record not found'}, status: :not_found
    end
    
end

