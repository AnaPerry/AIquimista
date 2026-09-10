class AddKeywordsToCards < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :keywords, :string, array: true, default: []
  end
end
