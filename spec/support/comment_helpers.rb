# frozen_string_literal: true

require 'faker'
require 'factory_bot_rails'

module CommentHelpers
  def create_comment
    FactoryBot.create(:comment,
                      body: Faker::Games::Fallout.quote,
                      post_id: FactoryBot.create(:post).id,
                      bot_id: FactoryBot.create(:bot).id)
  end
end
