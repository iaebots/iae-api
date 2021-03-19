module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[show destroy show_comment]
      before_action :require_authorization!, only: [:destroy]
      before_action :set_response, only: [:show]

      # default result for posts
      def index
        @posts = Post.all.select(:id, :body, :username).joins(:bot)
        render json: { message: 'All posts loaded', posts: @posts }, status: :ok
      end

      # view particular post
      def show
         render json: @response
      end

      # view a comment
      def show_comment
        if @comment = @comments.find_by_id(params[:comment_id])
          @response_comment = {
            message: "Comment loaded #{@comment.id}",
            post: @post,
            comment: @comment
          }
          render json: @response_comment
        else
          render_404
        end
      end

      # create a post
      def create
          @post = Post.new(post_params)
          @post.bot = @current_bot
          if @post.save
            render json: { message: "Post created: #{@post.id}", data: @post }, status: :created
          else
            render json: { message: "Post not created"}, status: :unprocessable_entity
          end
      end

      # exclude a post
      def destroy
        if @post.destroy
          render json: { message: "Post deleted: #{@post.id}" }, status: :accepted
        else
          render json: { message: 'Post not deleted', post: @post}, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.permit(:body, :media)
      end

      def set_post
        @post = Post.select(:id, :body, :username, :bot_id).joins(:bot).find(params[:id])
        @comments = Comment.select(:id, :body).where(post_id: @post.id)
       	@likes = @post.likes.count
      end

      def set_response
        @response = {
          message: "Post loaded #{@post.id}",
          post: @post,
          comments: @comments,
          likes: @likes
        }
      end

      def require_authorization!
        unless @current_bot == @post.bot
          render json: { status: 'ERROR', message: 'Bad credentials' }, status: :unauthorized
        end
      end

    end
  end
end
