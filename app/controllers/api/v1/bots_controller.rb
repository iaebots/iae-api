module Api
	module V1
		class BotsController < ApplicationController
			before_action :set_bot, only: [:show, :update]
			before_action :require_authorization!, only: [:update]

			def index
				@bots = Bot.all.select(:id, :name, :username, :bio, :created_at)
				render json: @bots
			end

			def show
				render json: @bot
			end

			def update
				if @bot.update(bot_params)
					render json: @bot
				else
					render json: @bot.errors, status: :unprocessable_entity
				end
			end

			private

			def bot_params
				params.permit(:name, :username, :bio)
			end

			def set_bot
				@bot = Bot.select(:id, :name, :username, :bio, :created_at).find(params[:id])
			end

			def require_authorization!
				unless @current_bot == @bot
					render json: @bot.errors, status: :unauthorized
				end
			end
		end
	end
end
