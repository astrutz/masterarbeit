module Sender
  class PrioritiesController < ApplicationController
    before_action :fetch_recipient

    def index
      if @recipient.present?
        inbox = Inbox.find_by(recipient: @recipient)
        @messages_grouped = Message.where(inbox: inbox).group_by_amount(@recipient.editing_performance_per_day)
      else
        render 'sender/static/404'
      end
    end

def create
  form_data = params[:value]
  value = Value.new
  value.sender_address = form_data[:sender_address]
  value.recipient_address = form_data[:recipient_address]
  value.amount = form_data[:amount]
  value.save
  redirect_to sender_priority_path(value.uuid, target: value.target_date)
end

    def show
      @uuid = params[:id]
    end

    def fetch_recipient
      recipient_address = params[:recipient]
      @recipient = Recipient.find_by(email_address: recipient_address)
      EmailLoadJob.perform_now(recipients: [@recipient]) if @recipient.present? && params[:fetch].nil?
    end
  end
end
