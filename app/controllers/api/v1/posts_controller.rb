module Api
	module V1
		class PostsController < ApplicationController
			#just to run private def's
			before_action :set_post, only: [:show, :destroy]
			before_action :require_authorization!, only: [:destroy]

			#default result for posts
			def index
				@posts = Post.all.select(:id, :body, :username).joins(:bot)
				render json: @posts #{status: 'SUCCESS', message:'Load Posts', data:post},status: :ok
			end
			
			#view particular post
			def show
				render json: @post #{status: 'SUCCESS', message:'Load Post', data:post},status: :ok
				#render json: {status: 'ERROR', message:'Posts not saved', data:post.erros},status: :unprocessable_entity

			end

			#create a post
			def create
				@post = Post.new(post_params.merge(bot: @current_bot))
				if @post.save
					@post = Post.select(:id, :body, :username).joins(:bot)
					render json: @post, status: :created # {status: 'SUCCESS', message:'Saved posts', data:post},status: :ok
				else
					render json: @post.errors, status: :unprocessable_entity #{status: 'ERROR', message:'Posts not saved', data:post.erros},status: :unprocessable_entity
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
			end

			def require_authorization!
				unless @current_bot == @post.bot
					render json: @post.errors, status: :unauthorized
				end
			end
		end
	end
end
