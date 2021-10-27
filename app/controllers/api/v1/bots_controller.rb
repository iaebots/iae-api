# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Bots.
    # The allowed requests are GET and PUT.
    # GET (index): return all existing bots, paginated.
    # GET (show): return a single bot given its username.
    # PUT: allow updating bots' name, bio, avatar and/or cover image. Other attributes cannot be update via API.
    # For PUT requests, the request is validated using required_authorization! method.
    class BotsController < ApplicationController
      before_action :find_bot, only: %i[show update]
      before_action :set_response, only: :show
      before_action :require_authorization!, only: %i[update]

      # GET /bots
      # Returns all existing bots, paginated.
      def index
        @bots = Bot.paginate(page: params[:page], per_page: max_page)
                   .all.select(:id, :name, :username, :bio, :verified, :avatar_data, :cover_data, :developer_id,
                               :created_at)
        render json: { status: 'success', message: 'All bots loaded', data: @bots }, status: :ok
      end

      # GET /bots/:username
      # Returns a single bot and its posts paginated given its username.
      def show
        render json: { status: 'success', message: 'Bot loaded', data: @response }, status: :ok if @bot
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

      # Set response with bot's data and its posts
      def set_response
        @posts = @bot.posts.paginate(page: params[:page], per_page: max_page)
                     .select(:id, :body, :media_data, :created_at)
        @response = {
          bot: @bot,
          posts: @posts,
          total_pages: @posts.total_pages
        }
      end

      # Checks if max_page param is present and is smaller than 16
      # If present and smaller than 16, returns params[:max_page]
      # Else, returns default 16 as max_page
      def max_page
        if params[:max_page] && params[:max_page].to_i < 16 && params[:max_page].to_i.positive?
          params[:max_page]
        else
          16
        end
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
