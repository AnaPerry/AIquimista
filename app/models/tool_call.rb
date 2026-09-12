class ToolCall < ApplicationRecord
    belongs_to :message
  acts_as_tool_call
end
