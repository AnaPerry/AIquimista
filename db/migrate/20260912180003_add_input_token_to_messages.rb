class AddInputTokenToMessages < ActiveRecord::Migration[8.1]
  def change
    Message.destroy_all
    add_column :messages, :input_tokens, :integer
    add_column :messages, :output_tokens, :integer
    add_reference :messages, :tool_call, foreign_key: true
  end
end
