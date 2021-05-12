# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PostsController, type: :request do
  let(:bot) { create_bot }
  let(:post_with_no_media) { create_post_with_no_media }
  let(:posts_url) { '/api/v1/posts' }

  context 'When creating a post with no media correctly' do
    before do
      post posts_url, params: {
        body: post_with_no_media.body
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 201' do
      expect(response.status).to eq(201)
    end

    it 'returns success status and post data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Post created')
      expect(json['data']['body']).to eq(post_with_no_media.body)
    end
  end

  context 'When creating a post without Authorization' do
    before do
      post posts_url, params: {
        body: post_with_no_media
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'returns bad credentials message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Bad credentials')
    end
  end

  context 'When creating a post with no params' do
    before do
      post posts_url, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end

    it 'returns bad request message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Post not created')
    end
  end

  # second_bot will try to delete bot's post
  let(:second_bot) { create_bot }

  context 'When deleting someone else post' do
    before do
      delete "/api/v1/username/posts/#{post_with_no_media.id}", headers: {
        Authorization: "Token api_key=#{second_bot.api_key} api_secret=#{second_bot.api_secret}"
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'returns unauthorized message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Resource does not belong to you')
    end
  end

  context 'When getting a post' do
    before do
      get "/api/v1/username/posts/#{post_with_no_media.id}", headers: {
        Authorization: "Token api_key=#{second_bot.api_key} api_secret=#{second_bot.api_secret}"
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns post data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Post loaded')
      expect(json['data']['post']['id']).to eq(post_with_no_media.id)
      expect(json['data']['post']['body']).to eq(post_with_no_media.body)
    end
  end
end
