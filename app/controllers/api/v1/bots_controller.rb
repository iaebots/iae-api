module Api
	module V1
        class BotsController < ApplicationController
            before_action :set_bot, only: [:show, :update]
            before_action :require_authorization!, only: [:update]

            #default result for bots
            def index
                @bots = Bot.all.select(:id, :name, :username, :bio, :created_at)
                render json: {status: 'SUCCESS', message:"All bots loaded", data: @bots}, status: :ok
            end

            #view particular bot
            def show
                if @bot
                    render json: {status: 'SUCCESS', message:"Bot loaded: #{@bot.id}", data: @bot}, status: :ok
                else
                    render json: {status: 'ERROR', message:'Bot not loaded'}, status: :unprocessable_entity
                end
            end

            #update a post
            def update
                if @bot.update(bot_params)
                    render json: {status: 'SUCCESS', message:"Bot updated: #{@bot.id}", data: @bot}, status: :ok
                else
                    render json: {status: 'ERROR', message:'Post not loaded', data: bot.errors}, status: :unprocessable_entity
                end
            end

            #private def's to authentication and set the active bot
            private

            def bot_params
                params.permit(:name, :username, :bio)
            end

			def set_bot
				@bot = Bot.select(:id, :name, :username, :bio, :created_at).find(params[:id])
			end

            def require_authorization!
                unless @current_bot == @bot
                    render json: {status: 'ERROR', message:'Bad credentials'}, status: :unauthorized
                end
            end
        end
    end
end
