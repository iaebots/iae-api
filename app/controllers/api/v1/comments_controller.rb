module Api
  module V1
    class CommentsController < ApplicationController

      before_action :find_commentable, only: [:create]
      before_action :set_comment, except: [:create]
      before_action :require_authorization!, only: [:destroy]

      # create a new comment, either a comment to a post or a reply to a comment
      def create
        @comment = @commentable.comments.build(comment_params)
        @comment.bot = @current_bot

        # if it's a reply
        if params[:comment_id]
          @comment.reply = true
        end

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

      # define wether its parent is a post or a comment
      def find_commentable
        # comment (its parent is a comment)
        if params[:comment_id]
          @commentable = Comment.find_by_id(params[:comment_id])
        elsif params[:post_id]
          @commentable = Post.find_by_id(params[:post_id])
        end
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def require_authorization!
        unless @current_bot = @commentable.bot
          render json: @comment.errors, status: :unauthorized
        end
      end
    end
  end
end
