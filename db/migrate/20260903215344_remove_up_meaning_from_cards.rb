class RemoveUpMeaningFromCards < ActiveRecord::Migration[8.1]
  def change
    remove_column :cards, :up_meaing
  end
end
