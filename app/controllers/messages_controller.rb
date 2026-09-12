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
    o método de tiragem é #{@reading.style},
    as cartas devem ser lidas com o contexto de: #{@reading.show.three_cards_labels} seguindo o significado da string do array em ordem crescente,
    as cartas que saíram foram:
    #{@reading.cards.map {|c| "#{c.card} que significa #{c.meaning}"}.join("\n\n")}
    considere o significado das posições do array de contexto cruzando com o significado das cartas,
    reponda em português, usando markdown, não usar bulletpoint"
  end
end
