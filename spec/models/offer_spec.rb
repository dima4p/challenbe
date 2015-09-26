require 'rails_helper'

describe Offer, type: :model do

  before :each do
    @valid_attrs ||=
        JSON(File.read(Rails.root.join(*%w[spec fixtures files response])))['offers']
          .first
  end

  subject { Offer.new @valid_attrs }

  describe '#initialize' do
    it 'intilizes payout' do
      expect(subject.payout).to eq 76566
    end

    it 'intilizes thumbnail' do
      expect(subject.thumbnail).to eq 'http://cdn3.sponsorpay.com/assets/15196/offerwall-02_square_60.jpg'
    end

    it 'intilizes title' do
      expect(subject.title).to eq 'Gratis Prepaid-SIM'
    end
  end   #initialize
end
