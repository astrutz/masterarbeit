# frozen_string_literal: true
class Message < ApplicationRecord
  belongs_to :inbox
  scope :processed, -> { where.not(processed_at: nil) }
  scope :unprocessed, -> { where(processed_at: nil) }
scope :matches_rules, lambda {
  rules = first.inbox.rules
  results = []
  rules.each do |rule|
    results << where(
      Message.arel_table[rule.field_to_search].matches("%#{rule.field_matcher}%")
       ).to_a
  end
  results.flatten.uniq.sort_by { |e| e[:send_at] }
}

  def value
    value = Value.find_by(uuid: value_header)
    value.present? ? value.amount : 0
  end
  def self.with_value(sorted: false)
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
    if sorted
      sort_by_value(messages)
    else
      messages
    end
  end
  def self.group_by_amount(editing_performance)
    messages_valued = with_value(sorted: true)
    messages_grouped = []
    current_group = []
    messages_valued.each_with_index do |message, i|
      current_group << message
      if ((i + 1) % editing_performance).zero?
        messages_grouped << current_group
        current_group = []
      end
    end
    messages_grouped << current_group if messages_valued.length % editing_performance != 0
    messages_grouped
  end
  def self.sort_by_value(messages)
    messages.sort_by do |x|
      [x.value_header.to_i, -x.send_at.to_i]
    end.reverse
  end
end