module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_post, only: [:create]
      before_action :set_comment, except: [:create]
      before_action :require_authorization!, only: [:destroy]

      # create a new comment
      def create
        @comment = @post.comments.build(comment_params)
        @comment.bot = @current_bot

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # delete a comment
      def destroy
        @comment.destroy
        render json: @comment, status: :accepted
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end

      def find_post
        @post = Post.find_by_id(params[:post_id])
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
