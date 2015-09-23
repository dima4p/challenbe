# Model OffersRequest defines the protocol to get the Offers
#
class OffersRequest
  class << self
    def get(params)
      params = params.dup
      params[:appid] = Rails.application.secrets[:appid]
      params[:format] = :json
      params[:device_id] = Rails.application.secrets[:device_id]
      params[:locale] = :de
      params[:ip] = Rails.application.secrets[:ip]
      params[:offer_types] = Rails.application.secrets[:offer_types]
      params[:timestamp] = Time.current.to_i
      params = process_params params
      uri = URI Rails.application.secrets[:api_url]
      uri.query = params.to_param
      res = Net::HTTP.get_response(uri)
      return I18n.t 'offers_request.bad_response', name: res.class unless res.is_a? Net::HTTPOK
      res = JSON.parse res.body
      res.slice! *%w[code count pages offers]
      res
    end

    private

    def process_params(params)
      params = Hash[params.sort]
      string = "#{params.to_param}&#{Rails.application.secrets[:api_key]}"
      params[:hashkey] = Digest::SHA1.hexdigest string
      params
    end
  end   # class << self
end
