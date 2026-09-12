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
    @three_cards_labels = ["1. Passado", "2. Presente", "3. Futuro"]
    @six_cards_labels = ["1. Situação atual", "2. Desafio", "3. Passado", "4. Futuro", "5. Você", "6. Resultado"]
    @celtic_cross_labels = ["Presente", "Influência iminente", "Destino", "Passado distante", "Passado recente", "Futuro", "Você", "Desenvolver da situação", "Emoções internas", "Resultado final" ]

    @labels = case @reading.style
                       when "3" then @three_cards_labels
                       when "6" then @six_cards_labels
                       else @celtic_cross_labels
                       end
    "você vai fazer uma análise de leitura de tarot.
    o assunto da leitura é #{@reading.subject},
    o método de tiragem é #{@reading.style},
    as cartas devem ser lidas com o contexto de: #{@labels} seguindo o significado da string do array em ordem crescente,
    as cartas que saíram foram:#{@reading.cards.map { |c| "#{c.card} que significa #{c.meaning}" }.join("\n\n")}
    considere o significado das posições do array de contexto cruzando com o significado das cartas,
    reponda em português, usando markdown, não usar bulletpoint"
  end
end
