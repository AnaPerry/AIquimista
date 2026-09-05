class Reading < ApplicationRecord
  belongs_to :user
  has_many :readings_cards, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :decks, dependent: :destroy

  act_as_chat
end
