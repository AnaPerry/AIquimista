class AddNameToDecks < ActiveRecord::Migration[8.1]
  def change
    add_column :decks, :name, :string
  end
end
