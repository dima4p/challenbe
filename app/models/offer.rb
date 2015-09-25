# Model Offer defines the Offer representation from the API
#
class Offer

  attr_accessor :title, :thumbnail, :payout

  def initialize(hash = {})
    @title = hash['title']
    @thumbnail = hash['thumbnail']
    @payout = hash['payout']
  end

end
