class ReadingsController < ApplicationController
  before_action :set_readings, only: %i[show,destroy]
  def show
  end

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
    @cartas = Card.order("RANDOM()").limit(@reading.style.to_i)
    @cartas.each do |carta|
      ReadingCard.create!(reading: @reading, card: carta)
    end
  end
end
