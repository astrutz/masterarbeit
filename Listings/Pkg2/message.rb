class Message < ApplicationRecord
  belongs_to :inbox

def self.with_value
  messages = all
  messages.each do |message|
    latest_value_creation = message.send_at + 30.minutes
    value = Value.where(
      uuid: message.value_header,
      recipient_address: message.recipient_address,
      sender_address: message.sender_address,
      created_at: ..latest_value_creation
    ).first

    next if message.value_header.nil? || value.nil?

    message.value_header = value.amount
  end
  messages
end

def self.group_by_amount(editing_performance)
  messages_valued = with_value.sort_by do |x|
    [x.value_header.to_i, -x.send_at.to_i]
  end
  messages_grouped = []
  current_group = []
  messages_valued.reverse.each_with_index do |message, i|
    current_group << message
    if ((i + 1) % editing_performance).zero?
      messages_grouped << current_group
      current_group = []
    end
  end
  messages_grouped << current_group if 
    messages_valued.length % editing_performance != 0
  messages_grouped
end
end