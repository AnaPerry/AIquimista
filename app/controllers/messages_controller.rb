class MessagesController < ApplicationController
  def create
    @reading = Reading.find(params[:reading_id])
    if @reading.with_instructions(instructions).ask(params[:message][:content])

      redirect_to reading_path(@reading)
    else
      render "readings/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    "responda em markdown"
  end
end
