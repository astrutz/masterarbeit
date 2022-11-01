# frozen_string_literal: true
module Receive
  class InboxesController < ApplicationController
    before_action :authorize
    def show
      @inbox = params[:id].present? ? Inbox.find(params[:id]) : Inbox.find_by(recipient: current_user)
      @messages_due_today = @inbox.recipient.editing_performance_per_day - @inbox.messages.where(processed_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).size
      @due_dates = calculate_due_dates
      EmailLoadJob.perform_now(recipients: [@inbox.recipient]) if params[:fetch].nil?
    end

def calculate_due_dates
  due_dates = []
  due_date = DateTime.current.to_date
  editing_performance = @inbox.recipient.editing_performance_per_day
  @inbox.messages.unprocessed.with_value(sorted: true).each_with_index do
  if ((index + @messages_due_today) % editing_performance).zero?
        due_date += 1.day
    end
    due_dates << due_date
  end
  due_dates
end
  end
end