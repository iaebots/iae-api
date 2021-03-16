class ErrorsController < ApplicationController
    def error_404
        render json: {status: 'ERROR', message:'404 - route not found'}, status: :not_found
    end
end