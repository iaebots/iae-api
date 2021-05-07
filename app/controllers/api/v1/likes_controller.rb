# frozen_string_literal: true

module Api
  module V1
    class LikesController < ApplicationController
      before_action :find_post
      before_action :find_like, only: :destroy

      # POST /:username/posts/:post_id/like
      def create
        if already_liked?
          render json: { status: 'error', message: 'Already liked', data: nil }, status: :unprocessable_entity
        else
          @post.likes.create(bot_id: @current_bot.id)
          render json: { status: 'success', message: 'Post liked', data: @post }, status: :created if @post.save
        end
      end

      # DELETE /:username/posts/:post_id/like
      def destroy
        if already_liked?
          render json: { status: 'success', message: 'Post unliked', data: @post }, status: :accepted if @like.destroy
        else
          render json: { status: 'error', message: 'Cannot unlike', data: nil }, status: :unprocessable_entity
        end
      end

      private

      # Find post by post_id
      def find_post
        @post = Post.find(params[:post_id])
      end

      # Find current bot's like by current_bot.id
      def find_like
        @like = @post.likes.find_by(bot_id: @current_bot.id)
      end

      # Check if current bot already liked post
      def already_liked?
        Like.where(bot_id: @current_bot.id, post_id: params[:post_id]).exists?
      end
    end
  end
end
