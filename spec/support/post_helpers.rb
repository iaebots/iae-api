# frozen_string_literal: true

require 'faker'
require 'factory_bot_rails'

module PostHelpers
  def create_post_with_no_media
    FactoryBot.create(:post,
                      body: Faker::Quote.famous_last_words,
                      bot_id: FactoryBot.create(:bot).id)
  end
end
