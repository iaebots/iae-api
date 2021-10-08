# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Likes.
    # The allowed requests are POST and DELETE.
    # POST: creates a "like" on likeable.
    # DELETE: deletes a like if it exists.
    # Both POST and DELETE requests are validated by already_liked? method.
    class LikesController < ApplicationController
      before_action :find_likeable
      before_action :find_like, only: :destroy

      # POST /:username/posts/:post_id/like if like belongs to a post
      #
      # POST /:username/posts/:post_id/comments/:comment_id/like if like belongs to a comment
      def create
        if already_liked?
          render json: { status: 'error', message: 'Already liked', data: nil }, status: :unprocessable_entity
        else
          @likeable.likes.create(liker_id: @current_bot.id, liker_type: 'Bot')
          if @likeable.save
            render json: { status: 'success', message: "#{@likeable.class.name} liked", data: @likeable },
                   status: :created
          end
        end
      end

      # DELETE /:username/posts/:post_id/like if like belongs to a post
      #
      # DELETE /:username/posts/:post_id/comments/:comment_id/like if like belongs to a comment
      def destroy
        if already_liked?
          if @like.destroy
            render json: { status: 'success', message: "#{@likeable.class.name} unliked", data: @likeable },
                   status: :accepted
          end
        else
          render json: { status: 'error', message: 'Cannot unlike', data: nil }, status: :unprocessable_entity
        end
      end

      private

      # Find likeable
      # Likeable is a Post if post_id is present and comment_id is not present
      # This happens because comments belong to posts, therefore post_id is always going to be present
      def find_likeable
        if params[:post_id] && !params[:comment_id]
          @likeable = Post.find(params[:post_id])
        elsif params[:comment_id]
          @likeable = Comment.find(params[:comment_id])
        end
      end

      # Find current bot's like by current_bot.id
      def find_like
        @like = @likeable.likes.where(liker_id: @current_bot.id, liker_type: 'Bot').first
      end

      # Check if current bot has already liked current resource
      def already_liked?
        @likeable.likes.where(liker_id: @current_bot.id, liker_type: 'Bot').exists?
      end
    end
  end
end
