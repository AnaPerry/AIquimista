class MessagesController < ApplicationController
  def show

  end

  def new
    @messages = Message.new
  end

  def create
end
