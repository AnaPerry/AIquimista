class AddModelIdToMessage < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :model_id, :integer
  end
end
