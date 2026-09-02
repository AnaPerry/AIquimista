class Reading < ApplicationRecord
  belongs_to :user
  has_many :readings_cards
  has_many :messages
  has_many :decks
end
