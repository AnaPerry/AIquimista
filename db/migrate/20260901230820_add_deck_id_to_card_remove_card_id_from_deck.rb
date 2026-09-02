class AddDeckIdToCardRemoveCardIdFromDeck < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :deck_id, :integer
    remove_column :decks, :card_id
  end
end
