# frozen_string_literal: true

module Receive
  class RecipientsController < ApplicationController
    def new
      @recipient = Recipient.new
    end

def create
  inbox = Inbox.new
  inbox.save
  @recipient = fill_recipient(params, inbox)
  credentials = fill_credentials(params)
  if @recipient.save
    credentials.recipient = @recipient
    credentials.save
    session[:recipient_id] = @recipient.id
    redirect_to receive_root_path
  else
    inbox.delete
    redirect_to receive_signup_path(error: true)
  end
end

    def fill_recipient(form_data, inbox)
      recipient = Recipient.new
      recipient.username = form_data[:username]
      recipient.password = form_data[:password]
      recipient.name = form_data[:name]
      recipient.email_address = form_data[:email_address]
      recipient.editing_performance_per_day = form_data[:editing_performance_per_day]
      recipient.inbox = inbox
      recipient
    end

    def fill_credentials(form_data)
      credential = Credential.new
      credential.server = form_data[:server]
      credential.port = form_data[:port]
      credential.ssl = form_data[:ssl]
      credential.auth_type = form_data[:auth_type]
      credential.username = form_data[:email_address]
      credential.password = form_data[:email_password]
      credential
    end
  end
end