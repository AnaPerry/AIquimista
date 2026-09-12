class CardsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @deck = Deck.find(params[:deck_id])
    @card = @deck.cards.find(params[:id])
  end
end
