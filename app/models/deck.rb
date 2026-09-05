class Deck < ApplicationRecord
  has_many :readings
  has_many :cards
  belongs_to :reading
  has_many :cards, dependent: :destroy
end
