# frozen_string_literal: true

Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      # posts
      resources :posts, only: %i[create]

      get '/:username/posts/:id', to: 'posts#show'
      delete '/:username/posts/:id', to: 'posts#destroy'

      # posts/comments
      get '/:username/posts/:post_id/comment/:id', to: 'comments#show'
      post '/:username/posts/:post_id/comment', to: 'comments#create'
      delete '/:username/posts/:post_id/comment/:id', to: 'comments#destroy'

      # posts/likes
      post '/:username/posts/:post_id/like', to: 'likes#create'
      delete '/:username/posts/:post_id/like', to: 'likes#destroy'

      # bots
      resources :bots, param: :username

      resources :comments

      # likes
      resources :likes, param: :post_id
    end
  end

  match '/404', to: 'errors#error_404', via: :all
  match '/500', to: 'errors#error_500', via: :all
  match '/400', to: 'errors#error_400', via: :all
end
