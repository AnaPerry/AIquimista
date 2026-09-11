# VALIDACAO FINAL DO BANCO
#
# Verifica:
# - quantidade de decks;
# - quantidade total de cartas;
# - quantidade de cartas por deck;
# - ausencia de duplicados;
# - presenca de imagens;
# - presenca de significados;
# - presenca de keywords;
# - correspondencia dos dados com a fonte traduzida PT-BR.

require "json"

# Carrega os dados traduzidos utilizados pelo seed.

translations_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br.json"
)

translated_cards = JSON.parse(File.read(translations_path))

puts "\n--- VALIDACAO FINAL DO BANCO ---"

# QUANTIDADE DE REGISTROS

puts "Decks: #{Deck.count}"
puts "Total de cards: #{Card.count}"
puts "Total esperado: 234"

puts "\nCartas por deck:"

Deck.all.each do |deck|
  puts "#{deck.name}: #{deck.cards.count}"
end

# DUPLICADOS

duplicates = Card
  .group(:deck_id, :card)
  .having("COUNT(*) > 1")
  .count

puts "\nDuplicados:"
puts "Cards duplicados por deck/nome: #{duplicates.count}"

if duplicates.any?
  duplicates.each do |(deck_id, card_name), count|
    deck = Deck.find(deck_id)

    puts "#{deck.name} - #{card_name}: #{count}"
  end
end

# INTEGRIDADE DOS DADOS

puts "\nIntegridade dos dados:"

puts "Cards com imagem: #{Card.joins(:image_attachment).distinct.count}"
puts "Cards sem meaning: #{Card.where(meaning: [nil, ""]).count}"
puts "Cards sem down_meaning: #{Card.where(down_meaning: [nil, ""]).count}"
puts "Cards sem keywords: #{Card.count { |card| card.keywords.blank? }}"

# Cria um indice das traducoes por nome.
# Como os tres decks compartilham os mesmos dados textuais,
# cada nome traduzido corresponde a uma unica carta de referencia.

translations_by_name = translated_cards.index_by do |card|
  card["name"]
end

incorrect_names = []
incorrect_suits = []
incorrect_keywords = []
incorrect_meanings = []
incorrect_down_meanings = []
missing_translations = []

Card.find_each do |card|
  translated = translations_by_name[card.card]

  unless translated
    missing_translations << "#{card.deck.name} - #{card.card}"
    next
  end

  if card.suit != translated["suit"]
    incorrect_suits << "#{card.deck.name} - #{card.card}"
  end

  if card.keywords != translated["keywords"]
    incorrect_keywords << "#{card.deck.name} - #{card.card}"
  end

  if card.meaning != translated["meaning"]
    incorrect_meanings << "#{card.deck.name} - #{card.card}"
  end

  if card.down_meaning != translated["down_meaning"]
    incorrect_down_meanings << "#{card.deck.name} - #{card.card}"
  end
end

# CORRESPONDENCIA COM A FONTE PT-BR

puts "\nCorrespondencia com a fonte PT-BR:"

puts "Cards sem traducao correspondente: #{missing_translations.count}"
puts "Cards com suit incorreto: #{incorrect_suits.count}"
puts "Cards com keywords incorretas: #{incorrect_keywords.count}"
puts "Cards com meaning incorreto: #{incorrect_meanings.count}"
puts "Cards com down_meaning incorreto: #{incorrect_down_meanings.count}"

if missing_translations.any?
  puts "\nCards sem traducao correspondente:"
  puts missing_translations
end

if incorrect_suits.any?
  puts "\nCards com suit incorreto:"
  puts incorrect_suits
end

if incorrect_keywords.any?
  puts "\nCards com keywords incorretas:"
  puts incorrect_keywords
end

if incorrect_meanings.any?
  puts "\nCards com meaning incorreto:"
  puts incorrect_meanings
end

if incorrect_down_meanings.any?
  puts "\nCards com down_meaning incorreto:"
  puts incorrect_down_meanings
end
