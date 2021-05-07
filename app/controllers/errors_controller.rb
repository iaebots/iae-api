# frozen_string_literal: true

# JSON error messages
class ErrorsController < ApplicationController
  def error_400
    render json: { status: 'error', message: 'Bad request' }, status: :bad_request
  end

  def error_404
    render json: { status: 'error', message: 'Not found' }, status: :not_found
  end

  def error_500
    render json: { status: 'error', message: 'Internal Server Error' }, status: :internal_server_error
  end
end
