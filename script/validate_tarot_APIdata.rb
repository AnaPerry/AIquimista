# VALIDACAO DAS FONTES EXTERNAS DE DADOS DO TAROT
#
# Este script verifica a compatibilidade entre a fonte de dados
# das cartas e as imagens utilizadas nos tres decks:
#
# - Rider-Waite-Smith
# - Tarot de Marseille
# - Sola Busca
#
# As validacoes confirmam quantidade, estrutura, nomenclatura
# e correspondencia entre os dados das cartas e suas imagens.
#
# Este arquivo nao cria registros no banco de dados.
# Ele serve apenas para validar as fontes externas utilizadas
# pelo seed da aplicacao.

require "net/http"
require "json"
require "open-uri"

# Primeira Verificacao: Verifica a quantidade de cartas informada para cada deck

puts "Rider-Waite-Smith: #{rider_waite_metadata["card_count"]} cartas"

puts "Tarot de Marseille: #{marseille_metadata["card_count"]} cartas"

puts "Sola Busca: #{sola_busca_metadata["card_count"]} cartas"

# Segunda verificacao: Como esses registros estao estruturados?
# Que campo permite ligar carta a imagem?

puts "\n--- EXEMPLO DA FONTE DE SIGNIFICADOS ---"
puts cards_data.first(3)

puts "\n--- EXEMPLO RIDER-WAITE ---"
puts rider_waite_metadata

puts "\n--- EXEMPLO MARSEILLE ---"
puts marseille_metadata["cards"].first(3)

puts "\n--- EXEMPLO SOLA BUSCA ---"
puts sola_busca_metadata["cards"].first(3)

# Terceira Verificacao: a sequencia numerica dos arquivos de imagem dos decks
# O objetivo e confirmar se existem imagens numeradas de 00 a 77
# sem numeros faltando antes de usarmos essa numeracao para associar
# cada imagem a uma carta.

marseille_numbers = marseille_metadata["cards"].map do |card|
  card["card"][0, 2].to_i
end

sola_busca_numbers = sola_busca_metadata["cards"].map do |card|
  File.basename(card["card"], ".*").to_i
end

expected_numbers = (0..77).to_a
missing_marseille_numbers = expected_numbers - marseille_numbers
missing_sola_busca_numbers = expected_numbers - sola_busca_numbers

puts "\n--- VERIFICACAO DA NUMERACAO DAS IMAGENS ---"
puts "Marseille:"
puts "Numeros encontrados: #{marseille_numbers.count}"
puts "Numeros faltando:"
p missing_marseille_numbers

puts "\nSola Busca:"
puts "Numeros encontrados: #{sola_busca_numbers.count}"
puts "Numeros faltando:"
p missing_sola_busca_numbers

# VALIDACAO ISOLADA DO TAROT DE MARSEILLE - 4/5/6/7 E 8 VALIDACAO
# Quarta Validacao: Examina a transicao entre os Arcanos Maiores e os Arcanos Menores
# do Tarot de Marseille.
# O objetivo e identificar como os nomes dos arquivos mudam depois
# dos 22 Arcanos Maiores e descobrir como podemos associar corretamente
# as imagens dos Arcanos Menores as cartas da fonte de significados.

puts "\n--- TRANSICAO MARSEILLE ---"
puts marseille_metadata["cards"][18, 10]

# Quinta Validacao: Examina a transicao entre os Arcanos Maiores e os Arcanos Menores
# na fonte de significados.
# O objetivo e verificar como numero, arcano e naipe sao representados
# para podermos relacionar cada carta com a imagem correspondente
# do Tarot de Marseille.

puts "\n--- TRANSICAO NA FONTE DE SIGNIFICADOS ---"
cards_data[18, 10].each do |card|
  puts "Nome: #{card["name"]} | Numero: #{card["number"]} | Arcano: #{card["arcana"]} | Naipe: #{card["suit"]}"
end

# Sexta Validacao: Examina como o Tarot de Marseille identifica as cartas finais
# de um naipe dos Arcanos Menores.
# O objetivo e descobrir como as cartas 10, Page, Knight,
# Queen e King aparecem nos nomes dos arquivos de imagem.

puts "\n--- FIGURAS DOS ARCANOS MENORES NO MARSEILLE ---"
marseille_metadata["cards"]
  .select { |card| card["card"].start_with?("Cups") }
  .each { |card| puts card["card"] }

# Resultado depois das validacoes 4/5 e 6:
# Arcanos Maiores: numero da carta
# Arcanos Menores: naipe + numero convertido

# Setima Validacao: Validacao final do Tarot de Marseille.
# Para cada uma das 78 cartas da fonte de significados,
# monta o nome esperado do arquivo de imagem no deck Marseille
# e verifica se essa imagem existe no metadata.

minor_numbers = {
  "Ace" => 1,
  "Two" => 2,
  "Three" => 3,
  "Four" => 4,
  "Five" => 5,
  "Six" => 6,
  "Seven" => 7,
  "Eight" => 8,
  "Nine" => 9,
  "Ten" => 10,
  "Page" => 11,
  "Knight" => 12,
  "Queen" => 13,
  "King" => 14
}

# Corrige a diferenca de nomenclatura dos naipes entre
# a fonte de significados e os arquivos do Tarot de Marseille.
# Apenas Pentacles tem um nome diferente no metadata do Marseille.
suit_mapping = {
  "Pentacles" => "Pents"
}

marseille_files = marseille_metadata["cards"].map { |card| card["card"] }
missing_marseille_images = []

cards_data.each do |card|

  if card["arcana"] == "Major"
    number = card["number"].to_i
    expected_prefix = format("%02d_", number)

    image_found = marseille_files.any? do |filename|
      filename.start_with?(expected_prefix)
    end
  else
    # Usa o nome corrigido do naipe quando necessario.
    # Exemplo: Pentacles -> Pents.
    # Para Cups, Swords e Wands, mantem o nome original.
    suit = suit_mapping[card["suit"]] || card["suit"]
    number = minor_numbers[card["number"]]
    expected_filename = "#{suit}#{format('%02d', number)}.png"
    image_found = marseille_files.include?(expected_filename)
  end
  missing_marseille_images << card["name"] unless image_found
end


puts "\n--- VALIDACAO FINAL MARSEILLE ---"
puts "Cartas verificadas: #{cards_data.count}"
puts "Imagens encontradas: #{cards_data.count - missing_marseille_images.count}"
puts "Cartas sem imagem correspondente: #{missing_marseille_images.count}"
puts "Cartas sem imagem:"
puts missing_marseille_images

# Oitava Validacao: Examina os diferentes prefixos usados nos arquivos dos Arcanos Menores
# do Tarot de Marseille.
# O objetivo e identificar como cada um dos quatro naipes esta nomeado
# antes de criar a regra de associacao com a fonte de significados.

puts "\n--- NAIPES DOS ARCANOS MENORES NO MARSEILLE ---"
minor_arcana_files = marseille_files.drop(22)
suit_prefixes = minor_arcana_files.map do |filename|
  filename.gsub(/\d+.*/, "")
end.uniq

puts suit_prefixes

# VALIDACAO ISOLADA DO SOLA BUSCA - 9/10
# Nona Validacao: O deck usa arquivos numerados de 00.jpg a 77.jpg.
# Verificamos se existe uma imagem para cada uma das 78 posicoes
# usadas pela fonte de significados.

sola_busca_files = sola_busca_metadata["cards"].map { |card| card["card"] }
missing_sola_busca_images = []
cards_data.each_with_index do |card, index|
  expected_filename = "#{format('%02d', index)}.jpg"
  image_found = sola_busca_files.include?(expected_filename)
  missing_sola_busca_images << card["name"] unless image_found
end

puts "\n--- VALIDACAO FINAL SOLA BUSCA ---"

puts "Cartas verificadas: #{cards_data.count}"
puts "Imagens encontradas: #{cards_data.count - missing_sola_busca_images.count}"
puts "Cartas sem imagem correspondente: #{missing_sola_busca_images.count}"

puts "Cartas sem imagem:"
puts missing_sola_busca_images

# Decima Validacao: Valida a ordem semantica do Sola Busca.
# Compara cartas em posicoes estrategicas da fonte de significados
# com os arquivos numerados do deck para confirmar se a sequencia
# 00-77 segue a mesma ordem das cartas.

check_indexes = [0, 1, 21, 22, 35, 36, 49, 50, 63, 64, 77]

puts "\n--- VALIDACAO DA ORDEM SOLA BUSCA ---"

check_indexes.each do |index|
  card = cards_data[index]
  filename = format("%02d.jpg", index)
  puts "#{index}: #{card["name"]} -> #{filename}"
end

# VALIDACAO ISOLADA RIDER-WAITE-SMITH - 11, 12, 13
# Decima primeira: Validacao do Rider-Waite-Smith.
# Busca a lista real de arquivos existentes na pasta de imagens do deck
# no repositorio GitHub.
# O objetivo e descobrir como as 78 imagens sao nomeadas para depois
# associa-las corretamente as 78 cartas da fonte de significados.

rider_waite_files_uri = URI(
  "https://api.github.com/repos/mixvlad/TarotCards/contents/tarot/rider-waite/full"
)

request = Net::HTTP::Get.new(rider_waite_files_uri)
request["User-Agent"] = "AIquimista"

response = Net::HTTP.start(
  rider_waite_files_uri.hostname,
  rider_waite_files_uri.port,
  use_ssl: true
) do |http|
  http.request(request)
end

rider_waite_files = JSON.parse(response.body)

puts "\n--- ESTRUTURA DAS IMAGENS RIDER-WAITE ---"

puts "Arquivos encontrados: #{rider_waite_files.count}"

rider_waite_files.first(10).each do |file|
  puts file["name"]
end

# Decima segunda: Verifica todos os arquivos existentes na pasta Rider-Waite.
# O objetivo e identificar por que existem 80 arquivos na pasta
# se o deck possui 78 cartas e descobrir quais arquivos nao
# correspondem a cartas do Tarot.

puts "\n--- TODOS OS ARQUIVOS RIDER-WAITE ---"

rider_waite_files.each do |file|
  puts file["name"]
end

# Decima terceira: Validacao final do Rider-Waite-Smith.
# Para cada uma das 78 cartas da fonte de significados,
# monta o nome esperado do arquivo de imagem no deck Rider-Waite
# e verifica se essa imagem existe entre os arquivos do repositorio.

rider_waite_image_files = rider_waite_files
  .map { |file| file["name"] }
  .reject { |filename| filename.start_with?("Cover") }

missing_rider_waite_images = []

cards_data.each do |card|

  if card["arcana"] == "Major"

    number = card["number"].to_i

    expected_prefix = format("%02d_", number)

    image_found = rider_waite_image_files.any? do |filename|
      filename.start_with?(expected_prefix)
    end

  else

    suit = suit_mapping[card["suit"]] || card["suit"]

    number = minor_numbers[card["number"]]

    expected_filename = "#{suit}#{format('%02d', number)}.jpg"

    image_found = rider_waite_image_files.include?(expected_filename)

  end

  missing_rider_waite_images << card["name"] unless image_found
end

puts "\n--- VALIDACAO FINAL RIDER-WAITE ---"

puts "Cartas verificadas: #{cards_data.count}"
puts "Imagens encontradas: #{cards_data.count - missing_rider_waite_images.count}"
puts "Cartas sem imagem correspondente: #{missing_rider_waite_images.count}"

puts "Cartas sem imagem:"
puts missing_rider_waite_images
