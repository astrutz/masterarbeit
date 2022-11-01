class Value < ApplicationRecord
  before_save :generate_uuid

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

def target_date
  recipient = Recipient.find_by(email_address: recipient_address)
  messages_grouped = Message.group_by_amount(recipient.editing_performance_per_day)
  days_to_wait = 1
  messages_grouped.each do |group|
    break if group.last.value_header.to_i < amount

    days_to_wait += 1
  end
  days_to_wait.days.from_now
end
end