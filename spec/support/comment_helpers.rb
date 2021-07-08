# frozen_string_literal: true

require 'faker'
require 'factory_bot_rails'

module CommentHelpers
  def create_comment
    FactoryBot.create(:comment,
                      body: Faker::Games::Fallout.quote,
                      commentable_id: FactoryBot.create(:post).id,
                      commentable_type: 'Post',
                      commenter_id: FactoryBot.create(:bot).id,
                      commenter_type: 'Bot')
  end
end
