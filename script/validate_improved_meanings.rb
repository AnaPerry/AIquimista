require "json"

original_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br.json"
)

improved_path = Rails.root.join(
  "db",
  "data",
  "tarot_cards_pt_br_improved.json"
)

original_cards = JSON.parse(File.read(original_path))
improved_cards = JSON.parse(File.read(improved_path))

puts "========================================"
puts "VALIDACAO DOS MEANINGS MELHORADOS"
puts "========================================"
puts

puts "Total original: #{original_cards.count}"
puts "Total improved: #{improved_cards.count}"

puts

original_ids = original_cards.map { |card| card["id"] }
improved_ids = improved_cards.map { |card| card["id"] }

puts "IDs unicos original: #{original_ids.uniq.count}"
puts "IDs unicos improved: #{improved_ids.uniq.count}"

missing_in_improved = original_ids - improved_ids
extra_in_improved = improved_ids - original_ids

puts "IDs ausentes no improved: #{missing_in_improved.count}"
puts "IDs extras no improved: #{extra_in_improved.count}"

puts
puts "----------------------------------------"
puts "INTEGRIDADE DOS CAMPOS"
puts "----------------------------------------"

puts "Sem name: #{improved_cards.count { |card| card["name"].to_s.strip.empty? }}"
puts "Sem meaning: #{improved_cards.count { |card| card["meaning"].to_s.strip.empty? }}"
puts "Sem down_meaning: #{improved_cards.count { |card| card["down_meaning"].to_s.strip.empty? }}"
puts "Sem keywords: #{improved_cards.count { |card| card["keywords"].nil? || card["keywords"].empty? }}"

puts
puts "----------------------------------------"
puts "COMPARACAO COM O ARQUIVO ORIGINAL"
puts "----------------------------------------"

original_by_id = original_cards.index_by { |card| card["id"] }
improved_by_id = improved_cards.index_by { |card| card["id"] }

changed_name = []
changed_suit = []
changed_keywords = []
changed_down_meaning = []
unchanged_meaning = []

improved_cards.each do |card|
  original = original_by_id[card["id"]]

  next unless original

  changed_name << card["id"] if card["name"] != original["name"]
  changed_suit << card["id"] if card["suit"] != original["suit"]
  changed_keywords << card["id"] if card["keywords"] != original["keywords"]
  changed_down_meaning << card["id"] if card["down_meaning"] != original["down_meaning"]

  unchanged_meaning << card["id"] if card["meaning"] == original["meaning"]
end

puts "Names alterados: #{changed_name.count}"
puts "Suits alterados: #{changed_suit.count}"
puts "Keywords alteradas: #{changed_keywords.count}"
puts "Down meanings alterados: #{changed_down_meaning.count}"
puts "Meanings que nao mudaram: #{unchanged_meaning.count}"

if unchanged_meaning.any?
  puts
  puts "Cartas com meaning inalterado:"

  unchanged_meaning.each do |id|
    card = improved_by_id[id]
    puts "#{id} - #{card["name"]}"
  end
end

puts
puts "----------------------------------------"
puts "AMOSTRAS"
puts "----------------------------------------"

sample_ids = [0, 2, 10, 21, 22, 36, 50, 77]

sample_ids.each do |id|
  original = original_by_id[id]
  improved = improved_by_id[id]

  next unless original && improved

  puts
  puts "ID #{id} - #{improved["name"]}"

  puts "Keywords:"
  puts improved["keywords"].join(" | ")

  puts
  puts "Meaning original:"
  puts original["meaning"]

  puts
  puts "Meaning improved:"
  puts improved["meaning"]

  puts
  puts "----------------------------------------"
end

puts
puts "========================================"
puts "FIM DA VALIDACAO"
puts "========================================"
