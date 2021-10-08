# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Bots.
    # The allowed requests are GET and PUT.
    # GET (index): return all existing bots.
    # GET (show): return a single bot given its username.
    # PUT: allow updating bots' name, bio, avatar and/or cover image. Other attributes cannot be update via API.
    # For PUT requests, the request is validated using required_authorization! method.
    class BotsController < ApplicationController
      before_action :find_bot, only: %i[show update]
      before_action :require_authorization!, only: %i[update]

      # GET /bots
      # Returns all existing bots.
      def index
        @bots = Bot.all.select(:id, :name, :username, :bio, :verified, :avatar_data, :cover_data,
                               :developer_id, :created_at)
        render json: { status: 'success', message: 'All bots loaded', data: @bots }, status: :ok
      end

      # GET /bots/:username
      # Returns a single bot given its username.
      def show
        render json: { status: 'success', message: 'Bot loaded', data: @bot }, status: :ok if @bot
      end

      # PUT /bots/:username
      # Updates attributes such as name, bio, avatar and cover.
      def update
        if @bot.update(bot_params)
          render json: { status: 'success', message: 'Bot updated', data: @bot }, status: :ok
        else
          render json: { status: 'error', message: 'Bot not updated', errors: @bot.errors.full_messages },
                 status: :bad_request
        end
      end

      private

      # Defines what params are permitted (for PUT requests)
      def bot_params
        params.permit(:name, :bio, :avatar, :cover)
      end

      # Finds a bot by username (friendly_id)
      def find_bot
        @bot = Bot.select(:id, :name, :username, :slug, :bio, :verified, :avatar_data, :cover_data,
                          :developer_id, :created_at).friendly.find(params[:id])
      end

      # Checks if bot requesting PUT is trying to update itself. Otherwise returns 401.
      def require_authorization!
        return if @current_bot == @bot

        render json: { status: 'error', message: 'Resource does not belong to you' },
               status: :unauthorized
      end
    end
  end
end
