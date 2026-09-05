class Reading < ApplicationRecord
  belongs_to :user
  has_many :reading_cards
  has_many :messages
  belongs_to :deck
  has_many :readings_cards, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :decks, dependent: :destroy
end
