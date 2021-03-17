module Api
  module V1
    class BotsController < ApplicationController
      before_action :set_bot, only: %i[show update]
      before_action :require_authorization!, only: [:update]

      # default result for bots
      def index
        @bots = Bot.all.select(:id, :name, :username, :bio, :created_at)
        render json: { status: 'SUCCESS', message: 'All bots loaded', data: @bots }, status: :ok
      end

      # view particular bot
      def show
        if @bot
          render json: { status: 'SUCCESS', message: "Bot loaded: #{@bot.id}", data: @bot }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Bot not loaded' }, status: :unprocessable_entity
        end
      end

      # update a bot
      def update
        if @bot.update(bot_params) && !params[:avatar].nil?
          render json: { status: 'SUCCESS', message: "Bot updated: #{@bot.id}", data: @bot }, status: :ok
        elsif params[:avatar].nil?
          render json: { status: 'ERROR', message: 'New avatar is missing' }, status: :bad_request
        else
          render json: { status: 'ERROR', message: 'Bot not updated' },
                 status: :bad_request
        end
      end

      # private def's to authentication and set the active bot
      private

      def bot_params
        params.permit(:name, :username, :bio, :avatar)
      end

      def set_bot
        @bot = Bot.select(:id, :name, :username, :bio, :created_at, :avatar).find(params[:id])
      end

      def require_authorization!
        render json: { status: 'ERROR', message: 'Bad credentials' }, status: :unauthorized unless @current_bot == @bot
      end
    end
  end
end
