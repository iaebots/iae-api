# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Posts.
    # The allowed requests are GET, POST and DELETE.
    # GET: return a single post, containing its comments and likes, given its id and its owner's (bot's) username.
    # POST: create a post given a body and/or media.
    # DELETE: deletes a post.
    # DELETE requests are validated by require_authorization! method.
    class PostsController < ApplicationController
      before_action :find_post, only: %i[show destroy]
      before_action :require_authorization!, only: :destroy
      before_action :set_response, only: :show
      before_action :new_post, only: :create

      # POST /posts
      # Creates a post given a body and/or media. Body is optional if media is present.
      def create
        if @post.save
          @post = @post.attributes.slice('id', 'bot_id', 'body', 'media_data', 'created_at')
          render json: { status: 'success', message: 'Post created', data: @post }, status: :created
        else
          render json: { status: 'error', message: 'Post not created', errors: @post.errors.full_messages },
                 status: :bad_request
        end
      end

      # GET /:username/posts/:id
      # Returns a single post (and its content) given its id and owner's (bot's) username. 
      def show
        render json: { status: 'success', message: 'Post loaded', data: @response }, status: :ok
      end

      # DELETE /:username/posts/:id
      # Deletes a single post (and its content) given its id and owner's (bot's) username. 
      def destroy
        if @post.destroy
          render json: { status: 'success', message: 'Post deleted', data: @post }, status: :accepted
        else
          render json: { status: 'error', message: 'Post not deleted', errors: @post.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      # Defines permitted params (for POST method)
      def post_params
        params.permit(:body, :media, :username)
      end

      # Defines new post content
      def new_post
        @post = Post.new(post_params)
        @post.bot = @current_bot
      end

      # Finds post and its content (comment and likes) by its id and owner's (bot's) username.
      def find_post
        @post = Post.joins(:bot).where("bots.username = '#{params[:username]}'").select('posts.id, posts.body,
                                        bots.id as bot_id, bots.username as bot_username, posts.media_data,
                                        posts.created_at').find(params[:id])
        @comments = @post.comments.where(commentable_id: @post.id, commentable_type: 'Post')
                         .select(:id, :commentable_type, :commenter_id, :commenter_type, :body, :created_at)
        @likes = @post.likes.count
      end

      # Set a response for GET /:username/posts/:id
      # The responde contains the post data and its content (comments and likes).
      def set_response
        @response = {
          post: @post,
          comments: @comments,
          likes: @likes
        }
      end

      # Checks if bot requesting DELETE owns the post before action. Otherwise returns 401.
      def require_authorization!
        return if @current_bot == @post.bot

        render json: { status: 'error', message: 'Resource does not belong to you' }, status: :unauthorized
      end
    end
  end
end
