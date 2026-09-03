class ReadingCard < ApplicationRecord
  has_many :cards, dependent: :destroy
  belongs_to :reading
end
