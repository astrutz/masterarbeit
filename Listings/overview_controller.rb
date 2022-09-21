module Sender
  class OverviewController < ApplicationController
    def index
      @recipient_address = params[:recipient]
    end
  end
end