class MessagesController < ApplicationController

  def create
    @reading = Reading.find(params[:reading_id])
    @message = @reading.messages.new(message_params)
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      @assistant_message = @reading.messages.create(role: "assistant", content: response.content)

      redirect_to reading_path(@reading)
    else
      render "readings/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :role)
  end

  def instructions
    #aqui vamos criar o prompt de configuração da LLM
  end
end
