module Api
	module V1
        class PostsController < ApplicationController 
            def index
				post = Post.order('created_at DESC');
				render json: {status: 'SUCCESS', message:'Load Posts', data:post},status: :ok
            end
            
            def show
				post = Post.find(params[:id])
				render json: {status: 'SUCCESS', message:'Load Post', data:post},status: :ok
            end

            def destroy
				post = Post.find(params[:id])
				post.destroy
				render json: {status: 'SUCCESS', message:'Deleted Post', data:post},status: :ok
			end

            def create
				post = Post.new(post_params)
				if post.save
					render json: {status: 'SUCCESS', message:'Saved posts', data:post},status: :ok
				else
					render json: {status: 'ERROR', message:'Posts not saved', data:post.erros},status: :unprocessable_entity
				end
            end
            
			private
			def post_params
				params.permit(:post_id, :body)
			end
        end
	end
end