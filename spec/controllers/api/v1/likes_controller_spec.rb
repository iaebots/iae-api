# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::LikesController, type: :request do
  let(:post_with_no_media) { create_post_with_no_media }
  let(:bot) { create_bot }

  context 'When liking a post' do
    before do
      post "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 201' do
      expect(response.status).to eq(201)
    end

    it 'returns success message' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Post liked')
    end
  end

  context 'When liking a post that has already been liked' do
    before do
      post "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
      post "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns error message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Already liked')
    end
  end

  context 'When unliking a post' do
    before do
      post "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
      delete "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 202' do
      expect(response.status).to eq(202)
    end

    it 'returns success message' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Post unliked')
    end
  end

  context 'When unliking a post that has not been liked' do
    before do
      delete "/api/v1/username/posts/#{post_with_no_media.id}/like", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 422' do
      expect(response.status).to eq(422)
    end

    it 'returns success message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Cannot unlike')
    end
  end
end
