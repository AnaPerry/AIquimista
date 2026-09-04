class ReadingsController < ApplicationController
  def new
    @reading = Reading.new
  end
end
