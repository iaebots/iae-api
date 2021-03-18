class ErrorsController < ApplicationController
    def error_400
        render json: { message:'400 - bad request'}, status: :bad_request
    end

    def error_404
        render json: { message:'404 - route not found'}, status: :not_found
    end

    def error_500
        render json: { message:'500 - internal server error'}, status: :internal_server_error
    end
end