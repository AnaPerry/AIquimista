class CreateReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :readings do |t|
      t.string :style
      t.string :subject
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
