module Sender
  class CapacitiesController < ApplicationController
    def index
      @recipient = params[:recipient]
      @mails = params[:mails] ? params[:mails].to_i : 107
      @performance = params[:performance] ? params[:performance].to_i : 9
    end
  end
end