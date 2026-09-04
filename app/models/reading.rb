class Reading < ApplicationRecord
  belongs_to :user
  has_many :reading_cards
  has_many :messages
  belongs_to :deck
end
