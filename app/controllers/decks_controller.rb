class DecksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @decks = Deck.all
  end

  def show
    @deck = Deck.find(params[:id])
    @cards = @deck.cards.order(:card_number)
  end
end
