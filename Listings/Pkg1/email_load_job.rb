class EmailLoadJob < ApplicationJob
  queue_as :default

def perform(*_args, recipients: Recipient.all)
  recipients.each do |recipient|
    credential = recipient.credential
    establish_connection(credential)
    messages = fetch_new_messages
    save_messages(messages)
  end
end

  def establish_connection(credential)
    Mail.defaults retriever_method :imap, credential: credential
  end

  def fetch_new_messages
    Mail.find(keys: %w[NOT SEEN], read_only: true)
  end

  def save_messages(messages)
    messages.each do |message|
      from = message.from.first
      to = message.to.first
      subject = message.subject
      send_at = message.date
      value_header = message.header['X-Pay2Mail-Priority']
      content = message.decoded
      duplicate = Message.find_by(
        sender_address: from, recipient_address: to, send_at: send_at
      )
      next if duplicate.present?

      recipient = Recipient.find_by(email_address: to)
      inbox = Inbox.find_by(recipient: recipient)
      message = Message.new(
        inbox: inbox, sender_address: from, recipient_address: to,
        subject: subject, send_at: send_at, content: content
      )
      message.value_header = value_header if value_header.present?
      message.save
    end
  end
end