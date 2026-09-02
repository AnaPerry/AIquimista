class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :reading_card
end
