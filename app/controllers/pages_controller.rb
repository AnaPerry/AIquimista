class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    cards = Card.order(:id)
    daily_index = Date.current.yday % cards.count
    @daily_card = cards.offset(daily_index).first
  end
end
