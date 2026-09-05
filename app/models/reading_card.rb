class ReadingCard < ApplicationRecord
  belongs_to :card
  belongs_to :reading
  belongs_to :card
end
