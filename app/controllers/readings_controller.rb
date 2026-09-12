class ReadingsController < ApplicationController
  before_action :set_reading, only: %i[show destroy]
  @three_cards_labels = ["1. Passado", "2. Presente", "3. Futuro"]
  @six_cards_labels = ["1. Situação atual", "2. Desafio", "3. Passado", "4. Futuro", "5. Você", "6. Resultado"]
  @celtic_cross_labels = ["Presente", "Influência iminente", "Destino", "Passado distante", "Passado recente", "Futuro", "Você", "Desenvolver da situação", "Emoções internas", "Resultado final" ]
  def show
    @message = Message.new
    @messages = @reading.messages
    @cards = @reading.cards.includes(image_attachment: :blob)
    @cards.each { |card| card.reversed = [true, false].sample }
  end

  def new
    @reading = Reading.new
    @message = Message.new
  end

  def create
    @reading = Reading.new(reading_params)
    @reading.user = current_user
    if @reading.save
      draw_cards
      redirect_to reading_path(@reading)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @readings = Reading.all
  end

  def destroy
    @reading.destroy
    redirect_to readings_path, status: :see_other
  end

  private

  def set_reading
    @reading = Reading.find(params[:id])
  end

  def reading_params
    params.require(:reading).permit(:style, :subject, :deck_id)
  end

  def draw_cards
    drawn_cards = @reading.deck.cards.order("RANDOM()").limit(@reading.style.to_i)

    drawn_cards.each_with_index do |card, index|
      ReadingCard.create!(reading: @reading, card: card, position: index)
    end
  end
end
