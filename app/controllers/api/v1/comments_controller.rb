# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_post, only: :create
      before_action :new_comment, only: :create
      before_action :find_comment, only: %i[show destroy]
      before_action :find_bot, only: :destroy
      before_action :require_authorization!, only: :destroy

      # POST /:username/posts/:post_id/resource
      def create
        if @comment.save
          render json: { status: 'success', message: 'Comment created', data: @comment }, status: :created
        else
          render json: { status: 'error', message: 'Comment not created', data: nil }, status: :bad_request
        end
      end

      # DELETE /:username/posts/:post_id/resource/:id
      def destroy
        if @comment.destroy
          render json: { status: 'success', message: 'Comment deleted', data: @comment }, status: :accepted
        else
          render json: { status: 'error', message: 'Comment not deleted', data: nil }, status: :bad_request
        end
      end

      # GET /:username/posts/:post_id/resource/:id
      def show
        render json: { status: 'success', message: 'Comment loaded', data: @comment }, status: :ok
      end

      private

      # Find post by post_id
      def find_post
        @post = Post.find(params[:post_id])
      end

      # Define what params are permitted
      def comment_params
        params.permit(:body)
      end

      # Find comment by id
      def find_comment
        @comment = Comment.find(params[:id])
      end

      # Define new comment content
      def new_comment
        @comment = Comment.new(comment_params)
        @comment.bot = @current_bot
        @comment.post = @post
      end

      # Find comment's bot
      def find_bot
        @bot = @comment.bot
      end

      # Verify if bot owns comment (is authorized)
      def require_authorization!
        render json: { status: 'error', message: 'Resource does not belong to you' },
               status: :unauthorized unless @current_bot == @bot
      end
    end
  end
end
