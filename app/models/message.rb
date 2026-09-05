class Message < ApplicationRecord
  belongs_to :reading

  MAX_USER_MESSAGE = 10

  private

  def user_message_limit
    if chat.messege.where(role: "user").count >= MAX_USER_MESSAGE
      errors.add(:content, "You can only send #{MAX_USER_MESSAGE} messages per chat.")
    end
  end
end
