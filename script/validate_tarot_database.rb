# VALIDACAO FINAL DO BANCO
#
# Verifica:
# - quantidade de decks;
# - quantidade total de cartas;
# - quantidade de cartas por deck;
# - presenca de imagens;
# - presenca dos significados;
# - correspondencia dos significados com a fonte original.

require "net/http"
require "json"

# Carrega a fonte original dos significados para comparar
# os dados da API com os dados armazenados no banco.

cards_uri = URI(
  "https://raw.githubusercontent.com/smallcat419/tarot-card-data/main/index.json"
)

cards_response = Net::HTTP.get(cards_uri)
cards_data = JSON.parse(cards_response)["cards"]

puts "\n--- VALIDACAO FINAL DO BANCO ---"

puts "Decks: #{Deck.count}"
puts "Total de cards: #{Card.count}"

puts "\nCartas por deck:"
puts "Rider-Waite-Smith: #{Deck.find_by(name: "Rider-Waite-Smith").cards.count}"
puts "Tarot de Marseille: #{Deck.find_by(name: "Tarot de Marseille").cards.count}"
puts "Sola Busca: #{Deck.find_by(name: "Sola Busca").cards.count}"

puts "\nIntegridade dos dados:"
puts "Cards com imagem: #{Card.joins(:image_attachment).distinct.count}"
puts "Cards sem meaning: #{Card.where(meaning: [nil, ""]).count}"
puts "Cards sem down_meaning: #{Card.where(down_meaning: [nil, ""]).count}"

# Compara os significados salvos no banco com a fonte original.

incorrect_meanings = []
incorrect_down_meanings = []

Card.find_each do |card|
  source_card = cards_data.find do |card_data|
    card_data["name"] == card.card
  end

  next unless source_card

  if card.meaning != source_card["upright"]["meaning"]
    incorrect_meanings << "#{card.deck.name} - #{card.card}"
  end

  if card.down_meaning != source_card["reversed"]["meaning"]
    incorrect_down_meanings << "#{card.deck.name} - #{card.card}"
  end
end

puts "\nCorrespondencia dos significados:"
puts "Cards com meaning incorreto: #{incorrect_meanings.count}"
puts "Cards com down_meaning incorreto: #{incorrect_down_meanings.count}"

if incorrect_meanings.any?
  puts "\nCards com meaning incorreto:"
  puts incorrect_meanings
end

if incorrect_down_meanings.any?
  puts "\nCards com down_meaning incorreto:"
  puts incorrect_down_meanings
end
