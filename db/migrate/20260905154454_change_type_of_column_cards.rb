class ChangeTypeOfColumnCards < ActiveRecord::Migration[8.1]
  def change
    change_column :cards, :down_meaning, :text
    change_column :cards, :meaning, :text
  end
end
