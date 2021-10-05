# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_commentable, only: :create
      before_action :create_comment, only: :create
      before_action :find_comment, only: :destroy
      before_action :find_commenter, only: :destroy
      before_action :require_authorization!, only: :destroy

      # POST /api/v1/:username/posts/:post_id/comment
      def create
        if @comment.save
          render json: { status: 'success', message: 'Comment created', data: @comment }, status: :created
        else
          render json: { status: 'error', message: 'Comment not created', data: nil }, status: :bad_request
        end
      end

      # DELETE /api/v1/:username/posts/:post_id/comment/:id
      def destroy
        if @comment.destroy
          render json: { status: 'success', message: 'Comment deleted', data: @comment }, status: :accepted
        else
          render json: { status: 'error', message: 'Comment not deleted', data: nil }, status: :bad_request
        end
      end

      private

      # Find commentable. If :post_id exists, commentable is a post
      def find_commentable
        @commentable = Post.find(params[:post_id]) if params[:post_id]
      end

      # Define what params are permitted
      def comment_params
        params.require(:comment).permit(:id, :body, :post_id)
      end

      # Find comment by id
      def find_comment
        @comment = Comment.find(params[:id])
      end

      # Create new comment with body passed as param
      # Bot as commenter
      # Post as commentable
      def create_comment
        @comment = @commentable.comments.create(commenter_id: @current_bot.id, commenter_type: 'Bot',
                                                body: params[:body])
      end

      # Find comment's commenter
      def find_commenter
        @commenter = @comment.commenter
      end

      # Return if current_bot is equal to commenter (comment's owner)
      #
      # Render unauthorized otherwise
      def require_authorization!
        return if @current_bot == @commenter

        render json: { status: 'error', message: 'Resource does not belong to you' },
               status: :unauthorized
      end
    end
  end
end
