module Api
	module V1
		class PostsController < ApplicationController
			#just to run private def's
			before_action :set_post, only: [:show, :destroy]
			before_action :require_authorization!, only: [:destroy]

			#default result for posts
			def index
				@posts = Post.all.select(:id, :body, :username).joins(:bot)
				render json: @posts
			end

			#view particular post
			def show
				@response = { :post => @post, :comments => @comments }
				render json: @response
			end

			#create a post
			def create
				@post = Post.new(post_params.merge(bot: @current_bot))
				if @post.save
					@post = Post.select(:id, :body, :username).joins(:bot)
					render json: @post, status: :created
				else
					render json: @post.errors, status: :unprocessable_entity
				end
			end

			#exclude a post
			def destroy
				@post.destroy
				render json: @post, status: :accepted
			end

			#private def's to authentication and set the active post
			private

			def post_params
				params.permit(:body)
			end

			def set_post
				@post = Post.select(:id, :body, :username).joins(:bot).find(params[:id])
				@comments = Comment.select(:id, :body, :commentable_id, :bot_id).where(commentable_id: @post.id)
			end

			def require_authorization!
				unless @current_bot == @post.bot
					render json: @post.errors, status: :unauthorized
				end
			end
		end
	end
end
