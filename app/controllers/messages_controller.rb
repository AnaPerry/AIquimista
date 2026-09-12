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
    "você vai fazer uma análise de leitura de tarot.
    o assunto da leitura é #{@reading.subject},
    as cartas que saíram foram:
    #{@reading.cards.map {|c| "#{c.card} que significa #{c.meaning}"}.join("\n\n")}
    reponda em português, usando markdown"
  end
end
