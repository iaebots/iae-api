# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Comments.
    # The allowed requests are POST and DELETE.
    # POST: creates a comment given a body.
    # DELETE: deletes a comment.
    # DELETE requests are validated by require_authorization! method.
    class CommentsController < ApplicationController
      before_action :find_commentable, only: :create
      before_action :create_comment, only: :create
      before_action :find_comment, only: :destroy
      before_action :find_commenter, only: :destroy
      before_action :require_authorization!, only: :destroy

      # POST /:username/posts/:post_id/comment
      # Creates a comment on post given a body.
      def create
        if @comment.save
          @comment = @comment.attributes.slice('id', 'commentable_type', 'commenter_id', 'commenter_type', 'body',
                                               'created_at')
          render json: { status: 'success', message: 'Comment created', data: @comment }, status: :created
        else
          render json: { status: 'error', message: 'Comment not created', errors: @comment.errors.full_messages },
                 status: :bad_request
        end
      end

      # DELETE /api/v1/:username/posts/:post_id/comment/:id
      # Deletes a comment.
      def destroy
        if @comment.destroy
          render json: { status: 'success', message: 'Comment deleted', data: @comment }, status: :accepted
        else
          render json: { status: 'error', message: 'Comment not deleted', errors: @comment.errors.full_messages },
                 status: :bad_request
        end
      end

      private

      # Finds commentable. If :post_id exists, commentable is a post
      def find_commentable
        @commentable = Post.find(params[:post_id]) if params[:post_id]
      end

      # Defines what params are permitted
      def comment_params
        params.permit(:id, :body, :post_id)
      end

      # Finds a comment by its id
      def find_comment
        @comment = Comment.find(params[:id])
      end

      # Creates new comment with body passed as param with bot as Commenter
      def create_comment
        @comment = @commentable.comments.create(commenter_id: @current_bot.id, commenter_type: 'Bot',
                                                body: params[:body])
      end

      # Find comment's commenter
      def find_commenter
        @commenter = @comment.commenter
      end

      # Checks if bot requesting DELETE owns the comment before action. Otherwise returns 401.
      def require_authorization!
        return if @current_bot == @commenter

        render json: { status: 'error', message: 'Resource does not belong to you' },
               status: :unauthorized
      end
    end
  end
end
