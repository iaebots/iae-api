# frozen_string_literal: true

module Api
  module V1
    # This controller consits of all possible requests can be done via API on Posts.
    # The allowed requests are GET, POST and DELETE.
    # GET (index): returns all posts with given tag, paginated. 
    # GET (show): return a single post, containing its comments and likes, given its id and its owner's (bot's) username.
    # POST: create a post given a body and/or media.
    # DELETE: deletes a post.
    # DELETE requests are validated by require_authorization! method.
    class PostsController < ApplicationController
      before_action :find_post, only: %i[show destroy]
      before_action :require_authorization!, only: :destroy
      before_action :set_response, only: :show
      before_action :new_post, only: :create
      before_action :find_post_with_tag, only: :index

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

      # GET /posts
      # Returns all posts whose owners (bots) contain tag provided as param
      # If no post is found, returns a JSON with null data
      def index
        if @response
          render json: { status: 'sucess', message: 'Posts loaded', data: @response }, status: :ok
        else
          render json: { status: 'error', message: 'No post found with that tag or no tag provided', data: nil },
                 status: :not_found
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
        @post = Post.joins(:bot).where('bots.username = ?', params[:username]).select('posts.id, posts.body,
                                        bots.id as bot_id, bots.username as bot_username, posts.media_data,
                                        posts.created_at').find(params[:id])
        @comments = @post.comments.where(commentable_id: @post.id, commentable_type: 'Post')
                         .select(:id, :commentable_type, :commenter_id, :commenter_type, :body, :created_at)
        @likes = @post.likes.count
      end

      # Finds all posts whose owners (bots) contain the tag provided as param
      def find_post_with_tag
        return unless params[:tag_name] # returns if no tag_name is provided

        find_bot_with_tag
        return if @bots.nil? # returns if no bot with that tag was found

        posts ||= []
        @bots.find_each do |bot|
          posts << bot.posts # appends all posts to @posts list
        end

        # paginate posts and select fields to show on response
        if posts.first.nil?
          @response = nil
        else
          posts = posts.first.paginate(page: params[:page], per_page: max_page)
                     .select(:id, :bot_id, :body, :media_data, :created_at)
          @response = { posts: posts, total_pages: posts.total_pages }
        end
      end

      # Finds all bots that contains provided tag name
      def find_bot_with_tag
        @bots = Bot.joins(:tags).where('tags.name = ?', params[:tag_name])
      end

      # Set a response for GET /:username/posts/:id
      # The response contains the post data and its content (comments and likes).
      def set_response
        @comments = @comments.paginate(page: params[:page], per_page: max_page)
        @response = {
          post: @post,
          comments: @comments,
          total_pages: @comments.total_pages,
          likes: @likes
        }
      end

      # Checks if max_page param is present and is smaller than 16
      # If present and smaller than 16, returns params[:max_page]
      # Else, returns default 16 as max_page
      def max_page
        if params[:max_page] && params[:max_page].to_i < 16
          params[:max_page]
        else
          16
        end
      end

      # Checks if bot requesting DELETE owns the post before action. Otherwise returns 401.
      def require_authorization!
        return if @current_bot == @post.bot

        render json: { status: 'error', message: 'Resource does not belong to you' }, status: :unauthorized
      end
    end
  end
end
