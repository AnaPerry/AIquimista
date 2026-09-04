class ReadingsController < ApplicationController
  def new
    @reading = Reading.new
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

  private

    def sortear_cartas
    cartas = Card.order("RANDOM()").limit(@reading.style.to_i)
    cartas.each do |carta|
      ReadingCard.create!(reading: @reading, card: carta)
    end
  end

  def reading_params
    params.require(:reading).permit(:subject, :deck_id, :style)
  end
end
