module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_post, only: [:create]
      before_action :set_comment, except: [:create]
      before_action :require_authorization!, only: [:destroy]

      # create a new comment
      def create
        @comment = @post.comments.create(body: comment_params, bot_id: @current_bot.id)
        if @comment
          render json: { message: 'Post commented.', comment: @comment }, status: :created
        else
          render json: { message: 'Comment not created.'}, status: :accepted
        end
      end

      # delete a comment
      def destroy
        if @comment.destroy
          render json: { message: 'Comment deleted.'}, status: :accepted
        else
          render json: { message: 'Comment not deleted.', comment: @comment }, status: :accepted
        end
      end

      private

      def find_post
        @post = Post.select(:id, :body, :username, :bot_id).joins(:bot).find(params[:post_id])
      end

      def comment_params
        params.require(:body)
      end 

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def require_authorization!
        unless @current_bot == @comment.bot
          render json: { status: 'ERROR', message: 'Unauthorized', data: @comment.errors }, status: :unauthorized
        end
      end
    end
  end
end
