class Card < ApplicationRecord
  belongs_to :deck

  has_one_attached :image

  has_many :reading_cards, dependent: :destroy
  has_many :readings, through: :reading_cards

  attr_accessor :reversed

  def reversed?
    !!reversed
  end
end
