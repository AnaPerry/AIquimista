 require "json"
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY")
end

input_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br.json"
)

output_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br_improved.json"
)

original_cards = JSON.parse(File.read(input_path))

cards =
  if File.exist?(output_path)
    JSON.parse(File.read(output_path))
  else
    JSON.parse(JSON.generate(original_cards))
  end

original_by_id = original_cards.index_by { |card| card["id"] }

puts "Cartas encontradas: #{original_cards.count}"
puts

cards.each_with_index do |card, index|
  original_card = original_by_id[card["id"]]

  if card["meaning"] != original_card["meaning"]
    puts "Pulando #{index + 1}/#{cards.count}: #{card["name"]} (ja processada)"
    next
  end

  puts
  puts "========================================"
  puts "Processando #{index + 1}/#{cards.count}: #{card["name"]}"

  # ETAPA 1 - WRITER
  writer = RubyLLM.chat(model: "gpt-4.1-mini")

  draft_response = writer.ask(<<~PROMPT)
    Reescreva o significado desta carta de Tarot em portugues brasileiro.

    O objetivo e tornar o texto natural e agradavel para a secao
    "Carta do Dia", sem alterar seu significado.

    REGRAS:

    - Use somente informacoes presentes no significado original
      ou nas palavras-chave.
    - Nao introduza nenhum conceito novo.
    - Nao utilize conhecimento externo sobre Tarot.
    - Nao remova nenhuma informacao presente no significado original.
    - Nao altere o sentido de nenhuma informacao.
    - Nao resuma o significado original.
    - Nao transforme o inicio em uma lista de palavras-chave.
    - Se o significado original comecar com uma lista de conceitos
      separados por virgulas, integre esses conceitos gramaticalmente
      ao texto.
    - Apenas reorganize linguisticamente o conteudo existente.
    - Escreva 1 ou 2 frases naturais quando isso for suficiente.
    - Use mais frases somente se necessario para preservar todas
      as informacoes do original.
    - Prefira preservar substantivos, verbos e conceitos do texto original.
    - E melhor manter uma expressao original do que substitui-la por
      uma ideia apenas semelhante.
    - A RESPOSTA FINAL deve usar corretamente acentos e cedilhas.
    - Nao use Markdown.
    - Nao explique sua resposta.
    - Retorne somente o novo significado.

    Carta:
    #{original_card["name"]}

    Palavras-chave:
    #{original_card["keywords"].join(", ")}

    Significado original:
    #{original_card["meaning"]}
  PROMPT

  draft = draft_response.content.strip

  # ETAPA 2 - AUDITOR
  auditor = RubyLLM.chat(model: "gpt-4.1-mini")

  final_response = auditor.ask(<<~PROMPT)
    Voce deve auditar uma reescrita de um significado de carta de Tarot.

    Sua tarefa NAO e interpretar a carta.

    Compare o texto candidato exclusivamente com o significado original
    e com as palavras-chave fornecidas.

    REGRAS:

    - Nenhuma informacao nova pode existir no texto final.
    - Nenhuma informacao do significado original pode ser removida.
    - Nenhuma informacao pode ter seu sentido alterado.
    - Nao utilize conhecimento externo sobre Tarot.
    - Uma palavra ou conceito novo nao pode ser mantido apenas porque
      parece relacionado com a carta.
    - Preserve todas as ideias, afirmacoes, orientacoes e consequencias
      existentes no significado original.
    - As palavras-chave podem ser usadas como conceitos permitidos,
      mas nao precisam ser enumeradas.
    - Remova qualquer conceito que nao possa ser diretamente sustentado
      pelo significado original ou pelas palavras-chave.
    - Se o candidato perdeu alguma informacao original, restaure-a.
    - Se o candidato alterou alguma informacao original, corrija-a.
    - Mesmo ao restaurar informacoes do significado original, nao restaure
      uma enumeracao inicial de conceitos.
    - Se o significado original comecar com uma lista de conceitos
      separados por virgulas, integre esses conceitos gramaticalmente
      ao texto final.
    - O texto final nao deve comecar como uma lista de palavras-chave.
    - Mantenha o texto natural e fluido.
    - Preserve o maximo possivel da formulacao original.
    - A RESPOSTA FINAL deve usar corretamente acentos e cedilhas.
    - Nao use Markdown.
    - Nao explique as correcoes.
    - Retorne SOMENTE o meaning final corrigido.

    VERIFICACAO FINAL:

    1. Existe alguma informacao no texto final que nao esteja presente
       no significado original ou nas palavras-chave?
       Se sim, remova.

    2. Existe alguma informacao do significado original que nao esteja
       presente no texto final?
       Se sim, restaure.

    3. Alguma informacao teve seu sentido alterado?
       Se sim, corrija.

    4. O texto comeca com uma enumeracao de palavras-chave?
       Se sim, integre esses conceitos em uma frase natural.

    O texto final deve ser semanticamente equivalente ao original:
    nao adicionar informacao, nao remover informacao e nao alterar seu sentido.

    Carta:
    #{original_card["name"]}

    Palavras-chave:
    #{original_card["keywords"].join(", ")}

    Significado original:
    #{original_card["meaning"]}

    Texto candidato:
    #{draft}
  PROMPT

  card["meaning"] = final_response.content.strip

  File.write(
    output_path,
    JSON.pretty_generate(cards)
  )

  puts "Salvo: #{card["name"]}"

  sleep 2
end

puts
puts "========================================"
puts "Processamento concluido."
puts "Arquivo:"
puts output_path
