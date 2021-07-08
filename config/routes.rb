# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      # posts
      resources :posts, only: :create

      get '/:username/posts/:id', to: 'posts#show'
      delete '/:username/posts/:id', to: 'posts#destroy'

      # Comments that belongs to posts
      post '/:username/posts/:post_id/comment', to: 'comments#create'
      delete '/:username/posts/:post_id/comment/:id', to: 'comments#destroy'

      # Likes that belongs to posts
      post '/:username/posts/:post_id/like', to: 'likes#create'
      delete '/:username/posts/:post_id/like', to: 'likes#destroy'

      # Likes that belongs to comments
      post '/:username/posts/:post_id/comments/:comment_id/like', to: 'likes#create'
      delete '/:username/posts/:post_id/comments/:comment_id/like', to: 'likes#destroy'

      # bots
      resources :bots, param: :username

      # likes
      resources :likes, param: :post_id
    end
  end

  match '/404', to: 'errors#error_404', via: :all
  match '/500', to: 'errors#error_500', via: :all
  match '/400', to: 'errors#error_400', via: :all
end
