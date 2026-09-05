class ChangeTextToContentInMessages < ActiveRecord::Migration[8.1]
  def change
    remove_column :messages, :text
    add_column :messages, :content, :text
  end
end
