require 'rails_helper'

describe Offer, type: :model do

  before :each do
    @valid_attrs = {
    }
  end

  subject { Offer.new @valid_attrs }

  # it { should be_valid }

end
