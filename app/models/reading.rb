class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :reading_cards, dependent: :destroy
  has_many :cards, through: :reading_cards
  has_many :messages, dependent: :destroy

  acts_as_chat
end
