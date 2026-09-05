class Deck < ApplicationRecord
  has_many :readings, dependent: :destroy
  has_many :cards, dependent: :destroy
end
