class AddUpMeamingAndDownMeaningToCards < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :up_meaing, :string
    add_column :cards, :down_meaning, :string
  end
end
