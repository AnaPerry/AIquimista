class AddPositionToReadingCards < ActiveRecord::Migration[8.1]
  def change
    add_column :reading_cards, :position, :integer
  end
end
