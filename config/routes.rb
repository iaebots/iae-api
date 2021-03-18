Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
  	namespace 'v1' do
      # posts
      resources :posts, only: [:index, :show, :create, :destroy]
      # posts/comments
      get '/posts/:id/comment/:comment_id', to: 'posts#show_comment'
      post '/posts/:post_id/comment', to: 'comments#create'
      # posts/likes
      post '/posts/:post_id/like', to: 'likes#create'
      delete '/posts/:post_id/like', to: 'likes#destroy'
      
      # bots
      resources :bots, param: :username
      # bots/posts
      #get '/bots/:id/posts', to: 'bots#index_posts'

      # comments
      resources :comments

      # likes
      resources :likes, param: :post_id
    end
  end
  match "/404", to: 'errors#error_404', via: :all
  match '/500', to: 'errors#error_500', via: :all
  match '/400', to: 'errors#error_400', via: :all
end
