# frozen_string_literal: true

require 'rails_helper'
require 'faker'

describe Api::V1::CommentsController, type: :request do
  let(:comment) { create_comment }
  let(:post_with_no_media) { create_post_with_no_media }
  let(:bot) { create_bot }

  context 'When creating a comment' do
    let(:body) { Faker::Games::Fallout.quote[0..32] }

    before do
      post "/api/v1/username/posts/#{post_with_no_media.id}/comment", params: {
        body: body
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 201' do
      expect(response.status).to eq(201)
    end

    it 'returns success message and comment data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Comment created')
      expect(json['data']['body']).to eq(body)
    end
  end

  context 'When creating a comment with no body' do
    before do
      post "/api/v1/username/posts/#{post_with_no_media.id}/comment", params: {
        body: ''
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end

    it 'returns error message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Comment not created')
    end
  end

  context 'When fetching a comment' do
    before do
      get "/api/v1/username/posts/#{comment.post_id}/comment/#{comment.id}", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns success message and comment data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Comment loaded')
      expect(json['data']['body']).to eq(comment.body)
    end
  end

  context 'When deleting another bot comment' do
    before do
      delete "/api/v1/username/posts/#{comment.post_id}/comment/#{comment.id}", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'returns error message' do
      expect(json['status']).to eq('error')
      expect(json['message']).to eq('Resource does not belong to you')
    end
  end
end
