class AddDeckIdToReadings < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :deck_id, :integer
    add_index :readings, :deck_id
  end
end
