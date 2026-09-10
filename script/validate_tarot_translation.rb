require "json"

cards = JSON.parse(
  File.read(
    Rails.root.join("db/data/tarot_cards_pt_br.json")
  )
)

puts "VALIDACAO DA TRADUCAO DO TAROT"
puts "--------------------------------"

# Validacao estrutural

puts "Total: #{cards.count}"
puts "IDs unicos: #{cards.map { |c| c["id"] }.uniq.count}"
puts "Sem nome: #{cards.count { |c| c["name"].blank? }}"
puts "Sem keywords: #{cards.count { |c| c["keywords"].blank? }}"
puts "Sem meaning: #{cards.count { |c| c["meaning"].blank? }}"
puts "Sem down_meaning: #{cards.count { |c| c["down_meaning"].blank? }}"

puts
puts "AMOSTRA DAS CARTAS"
puts "--------------------------------"

# Validacao de cartas distribuidas pelo deck

[0, 1, 21, 22, 36, 50, 64, 77].each do |id|
  card = cards.find { |c| c["id"] == id }

  puts "#{id}: #{card["name"]} | #{card["suit"]} | #{card["keywords"].join(" • ")}"
end
