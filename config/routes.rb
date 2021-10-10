# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      # posts
      resources :posts, only: %i[create index]

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
      resources :bots

      # likes
      resources :likes, param: :post_id
    end
  end

  # Config for Amazon S3 direct upload
  if Rails.env.development? || Rails.env.test?
    require 'ostruct'
    presign_endpoint = Shrine.presign_endpoint(lambda do |id, _opts, req|
      OpenStruct.new(url: "#{req.base_url}/attachments", key: "cache/#{id}")
    end)
    mount presign_endpoint => '/presign'
    mount AvatarUploader.upload_endpoint(:cache) => '/attachments'
    mount MediaUploader.upload_endpoint(:cache) => '/attachments'
  else
    mount Shrine.presign_endpoint(:cache) => '/presign'
  end

  match '/404', to: 'errors#error_404', via: :all
  match '/500', to: 'errors#error_500', via: :all
  match '/400', to: 'errors#error_400', via: :all
end
