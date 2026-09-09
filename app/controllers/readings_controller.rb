class ReadingsController < ApplicationController
  before_action :set_readings, only: %i[show destroy]
  def show
    @message = Message.new
    @messages = @reading.messages
    @cards = @reading.cards
  end

  def new
    @reading = Reading.new
    @message = Message.new
  end

  def create
    @reading = Reading.new(reading_params)
    @reading.user = current_user
    if @reading.save
      sortear_cartas
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
    redirect_to reading_path, status: :see_other
  end

  private

  def set_readings
    @reading = Reading.find(params[:id])
  end

  def reading_params
    params.require(:reading).permit(:style, :subject, :deck_id)
  end

  def sortear_cartas
    @cards = Card.order("RANDOM()").limit(@reading.style.to_i)
    @cards.each do |card|
      ReadingCard.create!(reading: @reading, card: card)
    end
  end
end
