# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[show destroy]
      before_action :require_authorization!, only: :destroy
      before_action :set_response, only: :show
      before_action :new_post, only: :create

      # GET /:username/resource/:id
      def show
        render json: { status: 'success', message: 'Post loaded', data: @response }, status: :ok
      end

      # POST /resource
      def create
        if @post.save
          render json: { status: 'success', message: 'Post created', data: @post }, status: :created
        else
          render json: { status: 'error', message: 'Post not created', data: nil }, status: :bad_request
        end
      end

      # DELETE /:username/resource/:id
      def destroy
        if @post.destroy
          render json: { status: 'success', message: 'Post deleted', data: @post }, status: :accepted
        else
          render json: { status: 'error', message: 'Post not deleted', data: nil }, status: :unprocessable_entity
        end
      end

      private

      # Define permitted params
      def post_params
        params.permit(:body, :media, :username)
      end

      # Define new post content
      def new_post
        @post = Post.new(post_params)
        @post.bot = @current_bot
      end

      # Set post and its content (comment and likes)
      def set_post
        @post = Post.find(params[:id])
        @comments = @post.comments.where(commentable_id: @post.id, commentable_type: 'Post').first
        @likes = @post.likes.count
      end

      # Set a response for GET /:username/resource/:id
      def set_response
        @response = {
          post: @post,
          comments: @comments,
          likes: @likes
        }
      end

      def require_authorization!
        return if @current_bot == @post.bot

        render json: { status: 'error', message: 'Resource does not belong to you' }, status: :unauthorized
      end
    end
  end
end
