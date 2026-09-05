class Card < ApplicationRecord
  belongs_to :deck
  has_many :reading_cards, dependent: :destroy
  has_many :readings, through: :reading_cards
end
