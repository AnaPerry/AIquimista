class CreateReadingCards < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_cards do |t|
      t.references :card, null: false, foreign_key: true
      t.references :reading, null: false, foreign_key: true

      t.timestamps
    end
  end
end
