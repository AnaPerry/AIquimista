class AddDeckToReadings < ActiveRecord::Migration[8.1]
  def change
    add_reference :readings, :deck, null: false, foreign_key: true
  end
end
