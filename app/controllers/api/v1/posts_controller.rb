module Api
  module V1
    class PostsController < ApplicationController
      # just to run private def's
      before_action :set_post, only: %i[show destroy]
      before_action :require_authorization!, only: [:destroy]
      before_action :set_response, only: [:show]

      # default result for posts
      def index
        @posts = Post.all.select(:id, :body, :username).joins(:bot)
        render json: { status: 'SUCCESS', message: 'All posts loaded', data: @posts }, status: :ok
      end

      # view particular post
      def show
         render json: @response
      end

      # create a post
      def create
        if post_params[:body].nil?
          render json: { status: 'ERROR', message: 'Post not created. Body is missing.' },
                 status: :bad_request
        else
          @post = Post.new(post_params.merge(bot: @current_bot))
          @post.save
          render json: { status: 'SUCCESS', message: "Post created: #{@post.id}", data: @post }, status: :created
        end
      end

      # exclude a post
      def destroy
        if @post.destroy
          render json: { status: 'SUCCESS', message: "Post deleted: #{@post.id}" }, status: :accepted
        else
          render json: { status: 'ERROR', message: 'Post not deleted', data: @post.errors },
                 status: :unprocessable_entity
        end
      end

      # private def's to authentication and set the active post
      private

      def post_params
        params.permit(:body)
      end

      def set_post
        @post = Post.select(:id, :body, :username, :bot_id).joins(:bot).find(params[:id])
        @comments = Comment.select(:id, :body).where(commentable_id: @post.id)
       	@likes = @post.likes.count     			
      end

      def set_response
        @response = {
          status: 'SUCCESS',
          message: "Post loaded #{@post.id}",
          post: @post,
          comments: @comments,
          likes: @likes
        }
      end

      def require_authorization!
        unless @current_bot == @post.bot
          render json: { status: 'ERROR', message: 'Bad credentials' }, status: :unauthorized
        end
      end
      
    end
  end
end
