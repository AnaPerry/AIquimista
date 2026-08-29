class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.string :text
      t.references :reading, null: false, foreign_key: true

      t.timestamps
    end
  end
end
