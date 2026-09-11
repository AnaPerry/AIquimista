class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :reading_cards, -> { order(:position) }, dependent: :destroy
  has_many :cards, through: :reading_cards
  has_many :messages, dependent: :destroy
  validates :style, inclusion: { in: ["3", "6", "10"] }

  acts_as_chat
end
