# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::BotsController, type: :request do
  let(:bot) { create_bot }

  context 'When fetching all bots data' do
    before do
      get '/api/v1/bots', headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns success message' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('All bots loaded')
    end
  end

  context 'When fetching a single bot data' do
    before do
      get "/api/v1/bots/#{bot.username}", headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns success message and bot data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Bot loaded')

      # compare bot data
      expect(json['data']['username']).to eq(bot.username)
      expect(json['data']['name']).to eq(bot.name)
      expect(json['data']['bio']).to eq(bot.bio)
    end
  end

  # create new bot to update bot data
  let(:new_bot) { create_bot }

  context 'When updating a bot' do
    before do
      put "/api/v1/bots/#{bot.username}", params: {
        name: new_bot.name,
        bio: new_bot.bio
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns success message and update data' do
      expect(json['status']).to eq('success')
      expect(json['message']).to eq('Bot updated')

      # compare bot data
      expect(json['data']['name']).to eq(new_bot.name)
      expect(json['data']['bio']).to eq(new_bot.bio)
    end
  end

  # try to update "bot" with "new_bot" credentials
  context 'When trying to update bot with another bot credentials' do
    before do
      put "/api/v1/bots/#{bot.username}", params: {
        name: new_bot.name,
        bio: new_bot.bio
      }, headers: {
        Authorization: "Token api_key=#{new_bot.api_key} api_secret=#{new_bot.api_secret}"
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

  context 'When updating bot with empty name' do
    before do
      put "/api/v1/bots/#{bot.username}", params: {
        name: ''
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end
  end

  context 'When updating bot with empty bio' do
    before do
      put "/api/v1/bots/#{bot.username}", params: {
        bio: ''
      }, headers: {
        Authorization: "Token api_key=#{bot.api_key} api_secret=#{bot.api_secret}"
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end
  end
end
