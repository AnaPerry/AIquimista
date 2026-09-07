# Rider-Waite-Smith, Tarot de Marseille e Sola Busca

require "net/http"
require "json"
require "open-uri"

# FONTE 1 - Tarot Card Data
# Busca os dados e significados das 78 cartas:
# nome, numero, arcano, naipe, significado normal e significado invertido.

cards_uri = URI(
  "https://raw.githubusercontent.com/smallcat419/tarot-card-data/main/index.json"
)

cards_response = Net::HTTP.get(cards_uri)
cards_data = JSON.parse(cards_response)["cards"]

puts "Cartas encontradas na fonte de dados: #{cards_data.count}"


# FONTE 2 - mixvlad/TarotCards
# Repositorio usado como fonte das imagens dos tres decks:
# Rider-Waite-Smith, Tarot de Marseille e Sola Busca.


# Rider-Waite-Smith
# O metadata nao lista todas as 78 imagens.
# Por isso, buscamos diretamente os arquivos existentes na pasta "full".
rider_waite_files_uri = URI(
  "https://api.github.com/repos/mixvlad/TarotCards/contents/tarot/rider-waite/full"
)
request = Net::HTTP::Get.new(rider_waite_files_uri)
request["User-Agent"] = "AIquimista"

rider_waite_response = Net::HTTP.start(
  rider_waite_files_uri.hostname,
  rider_waite_files_uri.port,
  use_ssl: true
) do |http|
  http.request(request)
end

rider_waite_files = JSON.parse(rider_waite_response.body)


# Tarot de Marseille
marseille_metadata_uri = URI(
  "https://raw.githubusercontent.com/mixvlad/TarotCards/main/tarot/marseille/metadata.json"
)
marseille_metadata =
  JSON.parse(Net::HTTP.get(marseille_metadata_uri))


# Sola Busca
sola_busca_metadata_uri = URI(
  "https://raw.githubusercontent.com/mixvlad/TarotCards/main/tarot/sola-busca/metadata.json"
)
sola_busca_metadata =
  JSON.parse(Net::HTTP.get(sola_busca_metadata_uri))

# MAPEAMENTO PARA RIDER-WAITE E MARSEILLE

# Converte os valores dos Arcanos Menores para a numeracao
# utilizada nos nomes dos arquivos de imagem dos decks.
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

# Nos arquivos do Rider-Waite e Marseille,
# Corrige a diferenca de nomenclatura do naipe Pentacles
# que aparece abreviado como "Pents"
suit_mapping = {
  "Pentacles" => "Pents"
}

# CRIACAO DOS DECKS
rider_waite_deck = Deck.find_or_create_by!(
  name: "Rider-Waite-Smith"
)

marseille_deck = Deck.find_or_create_by!(
  name: "Tarot de Marseille"
)

sola_busca_deck = Deck.find_or_create_by!(
  name: "Sola Busca"
)

puts "Decks criados:"
puts rider_waite_deck.name
puts marseille_deck.name
puts sola_busca_deck.name

# CRIACAO DAS 78 CARTAS DO RIDER-WAITE-SMITH

puts "Criando cartas do Rider-Waite-Smith..."

cards_data.each do |card_data|

  if card_data["arcana"] == "Major"
    number = card_data["number"].to_i
    expected_prefix = format("%02d_", number)

    image_file = rider_waite_files.find do |file|
      file["name"].start_with?(expected_prefix)
    end

  else
    suit = suit_mapping[card_data["suit"]] || card_data["suit"]
    number = minor_numbers[card_data["number"]]

    expected_filename = "#{suit}#{format('%02d', number)}.jpg"

    image_file = rider_waite_files.find do |file|
      file["name"] == expected_filename
    end
  end

  card = Card.find_or_create_by!(
    card: card_data["name"],
    deck: rider_waite_deck
  ) do |new_card|
    new_card.card_number = card_data["number"]
    new_card.suit = card_data["suit"]
    new_card.meaning = card_data["upright"]["meaning"]
    new_card.down_meaning = card_data["reversed"]["meaning"]
  end

  unless card.image.attached?
    card.image.attach(
      io: URI.open(image_file["download_url"]),
      filename: image_file["name"],
      content_type: "image/jpeg"
    )
  end

  puts "Criada: #{card.card}"
end

puts "Rider-Waite-Smith finalizado: #{rider_waite_deck.cards.count} cartas."
