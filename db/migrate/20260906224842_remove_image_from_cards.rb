class RemoveImageFromCards < ActiveRecord::Migration[8.1]
  def change
    remove_column :cards, :image, :string
  end
end
