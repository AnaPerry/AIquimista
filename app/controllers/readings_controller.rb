class ReadingsController < ApplicationController
  before_action :set_readings, only: %i[show,destroy]
  def show
  end

  def new
    @reading = Reading.new
  end

  def create
    @reading = Reading.new(reading_params)
    if @reading.save
      redirect_to reading_path
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
    params.require(:reading).permit(:style, :subject)
  end
end
