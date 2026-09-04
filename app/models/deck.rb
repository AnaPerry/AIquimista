class Deck < ApplicationRecord
  has_many :readings
  has_many :cards
end
