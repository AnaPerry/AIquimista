class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.string :card
      t.string :meaning
      t.string :image
      t.integer :card_number
      t.string :suit
      t.string :deck

      t.timestamps
    end
  end
end
