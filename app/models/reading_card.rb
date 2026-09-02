class ReadingCard < ApplicationRecord
  has_many :cards
  belongs_to :reading
end
