# This is the main controller to process model Offer
#
class OffersController < ApplicationController

  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  # GET /offers.json
  def index
    @offers_request = OffersRequest.new params[:offers_request] && offers_request_params
    if params[:offers_request] && @offers_request.valid?
      @offers = @offers_request.fetch!
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def offers_request_params
    list = [:uid, :pub0, :page, :pages]
    params.require(:offers_request).permit(*list)
  end
end
