class CreateToolCalls < ActiveRecord::Migration[8.1]
  def change
    create_table :tool_calls do |t|
      t.references :message, null: false, foreign_key: true
      t.string :name
      t.text :arguments
      t.references :parent_tool_call, foreign_key: { to_table: :tool_calls }
      t.references :result, foreign_key: { to_table: :tool_calls }

      t.timestamps
    end
  end
end
