module Api
  module V1
    class LikesController < ApplicationController
      before_action :find_post
      before_action :already_liked?, only: [:create]
      before_action :find_like, only: [:destroy]

      # creates a new like to a post
      def create
        if already_liked?
          render json: { status: 'ERROR', message: 'Already liked.', data: @post },
                 status: :unprocessable_entity
        else
          @post.likes.create(bot_id: @current_bot.id)
          render json: @post, status: :created
        end
      end

      # deletes a like, unlik a post
      def destroy
        if already_liked?
          @like.destroy
          render json: @post.likes.count, status: :accepted
        else
          render json: { status: 'ERROR', message: 'Cannot unlike', data: @like }, status: :unprocessable_entity
        end
      end

      private

      def find_post
        @post = Post.find(params[:post_id])
      end

      def already_liked?
        Like.where(bot_id: @current_bot.id, post_id: params[:post_id]).exists?
      end

      def find_like
        @like = @post.likes.find_by(bot_id: @current_bot.id)
      end
    end
  end
end
