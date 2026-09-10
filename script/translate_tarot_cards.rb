require "net/http"
require "json"
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY")
end

# Busca os dados originais das 78 cartas
cards_uri = URI(
  "https://raw.githubusercontent.com/smallcat419/tarot-card-data/main/index.json"
)

cards_response = Net::HTTP.get(cards_uri)
cards_data = JSON.parse(cards_response)["cards"]

puts "Cartas encontradas: #{cards_data.count}"

# Caminho do arquivo traduzido
output_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br.json"
)

# Se o arquivo ja existir, recupera as traducoes anteriores.
# Assim o script pode continuar de onde parou.
translated_cards =
  if File.exist?(output_path)
    JSON.parse(File.read(output_path))
  else
    []
  end

translated_ids = translated_cards.map { |card| card["id"] }

puts "Cartas ja traduzidas: #{translated_cards.count}"

chat = RubyLLM.chat(model: "gpt-4.1-mini")

cards_data.each_with_index do |card, index|

  # Pula cartas que ja foram traduzidas
  next if translated_ids.include?(card["id"])

  puts "Traduzindo #{index + 1}/#{cards_data.count}: #{card["name"]}"

  content_to_translate = {
    name: card["name"],
    suit: card["suit"],
    keywords: card["keywords"],
    meaning: card["upright"]["meaning"],
    down_meaning: card["reversed"]["meaning"]
  }

  begin
    response = chat.ask(<<~PROMPT)
      Traduza os dados desta carta de Tarot para português brasileiro.

      Regras:
      - Use terminologia tradicional de Tarot em português do Brasil.
      - Preserve o significado do texto original.
      - Nao acrescente interpretacoes.
      - Nao remova informacoes.
      - Traduza as keywords de forma curta e natural.
      - Preserve keywords como um array.
      - Se suit for null, mantenha null.
      - Retorne SOMENTE o objeto JSON.
      - Nao use blocos de codigo Markdown.
      - Nao escreva ```json ou ```.
      - Use exatamente estas chaves:
        name, suit, keywords, meaning, down_meaning.

      Dados:
      #{JSON.generate(content_to_translate)}
    PROMPT

    translated_card = JSON.parse(response.content)

    # Mantém o ID da fonte original
    translated_card["id"] = card["id"]

    translated_cards << translated_card
    translated_ids << card["id"]

    # Salva apos cada carta.
    # Assim nao perdemos o progresso se o script for interrompido.
    File.write(
      output_path,
      JSON.pretty_generate(translated_cards)
    )

    puts "Salva: #{translated_card["name"]}"

    # Pequena pausa para reduzir risco de rate limit
    sleep 2

  rescue RubyLLM::RateLimitError => e
    puts
    puts "Rate limit atingido."
    puts "As traducoes ja concluidas foram salvas."
    puts "Execute o script novamente para continuar."
    puts
    puts e.message
    break

  rescue JSON::ParserError => e
    puts
    puts "Erro ao interpretar a traducao de #{card["name"]}."
    puts "Resposta recebida:"
    puts response.content
    puts
    puts e.message
    break
  end
end

puts
puts "Traducoes salvas: #{translated_cards.count}/#{cards_data.count}"
puts "Arquivo:"
puts output_path

if translated_cards.count == cards_data.count
  puts "Traducao das 78 cartas concluída."
else
  puts "Traducao ainda incompleta. Execute novamente para continuar."
end
