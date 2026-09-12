class AddModelIdToReading < ActiveRecord::Migration[8.1]
  def change
    add_column :readings, :model_id, :integer
  end
end
