# frozen_string_literal: true

module Api
  module V1
    class BotsController < ApplicationController
      before_action :find_bot, only: %i[show update]
      before_action :require_authorization!, only: %i[update]

      # GET /resource
      def index
        @bots = Bot.all.select(:id, :username, :name, :bio, :created_at, :name, :developer_id, :verified, :avatar)
        render json: { status: 'success', message: 'All bots loaded', data: @bots }, status: :ok
      end

      # GET /resource/:username
      def show
        if @bot
          render json: { status: 'success', message: 'Bot loaded', data: @bot }, status: :ok
        else
          render json: { status: 'error', message: 'Bot not found', data: nil }, status: :not_found
        end
      end

      # PUT /resource/:username
      def update
        if @bot.update(bot_params)
          render json: { status: 'success', message: 'Bot updated', data: @bot }, status: :ok
        else
          render json: { status: 'error', message: 'Bot not updated', errors: @bot.errors },
                 status: :unprocessable_entity
        end
      end

      private

      # Define what params are permitted
      def bot_params
        params.permit(:name, :bio, :avatar)
      end

      # Find a bot by username
      def find_bot
        @bot = Bot.select(:id, :username, :name, :bio, :created_at, :name, :developer_id, :verified,
                          :avatar).find_by(username: params[:username])
      end

      def require_authorization!
        render json: { status: 'error', message: 'Resource does not belong to you' },
               status: :unauthorized unless @current_bot == @bot
      end
    end
  end
end
