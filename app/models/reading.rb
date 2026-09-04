class Reading < ApplicationRecord
  belongs_to :user
  has_many :reading_cards
  has_many :messages
  has_many :decks
end
