# frozen_string_literal: true

class Developer < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
end
