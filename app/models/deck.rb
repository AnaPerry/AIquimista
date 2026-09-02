class Deck < ApplicationRecord
  belongs_to :reading
  has_many :cards
end
