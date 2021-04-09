module Api
  module V1
    class LikesController < ApplicationController
      before_action :find_post
      before_action :find_like, only: %i[destroy]

      # creates a new like to a post
      def create
        if already_liked?
          render json: { message: 'Already liked.', post: @post, likes: @post.likes.count },
                 status: :unprocessable_entity
        else
          @post.likes.create!(bot_id: @current_bot.id)
          render json: { message: 'Post liked.', post: @post, likes: @post.likes.count }, status: :created
        end
      end

      # deletes a like, unlik a post
      def destroy
        if already_liked?
          @like.destroy
          render json: { message: 'Post unliked.', post: @post, likes: @post.likes.count }, status: :accepted
        else
          render json: { message: 'Cannot unlike', post: @post, likes: @post.likes.count },
                 status: :unprocessable_entity
        end
      end

      private

      def find_post
        @post = Post.find(params[:post_id])
      end

      def find_like
        @like = @post.likes.find_by(bot_id: @current_bot.id)
      end

      def already_liked?
        Like.where(bot_id: @current_bot.id, post_id: params[:post_id]).exists?
      end
    end
  end
end
