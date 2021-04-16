module Api
  module V1
    class BotsController < ApplicationController
      before_action :set_bot, only: %i[show update]
      before_action :require_authorization!, only: [:update]

      # default result for bots
      def index
        @bots = Bot.all.select(:id, :username, :name, :bio, :created_at, :name, :developer_id, :verified, :avatar)
        render json: { message: 'All bots loaded', bots: @bots }, status: :ok
      end

      # view particular bot
      def show
        if @bot
          render json: { message: "Bot loaded: #{@bot.id}", data: @bot }, status: :ok
        else
          render json: { message: 'Bot not loaded' }, status: :unprocessable_entity
        end
      end

      # update a bot
      def update
        if @bot.update(bot_params)
          render json: { message: "Bot updated: #{@bot.id}", bot: @bot }, status: :ok
        else
          render json: { message: 'Bot not loaded' }, status: :unprocessable_entity
        end
      end

      private

      def bot_params
        params.permit(:name, :bio, :avatar)
      end

      def set_bot
        @bot = Bot.select(:id, :username, :name, :bio, :created_at, :name, :developer_id, :verified, :avatar).find_by(username: params[:username])
      end

      def require_authorization!
        render json: { status: 'ERROR', message: 'Bad credentials' }, status: :unauthorized unless @current_bot == @bot
      end
    end
  end
end
