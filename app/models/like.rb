class Like < ApplicationRecord
  belongs_to :post
  belongs_to :bot, optional: true
end
