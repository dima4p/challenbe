require 'rails_helper'

describe OffersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Offer. As you add validations to Offer, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:valid_attributes) { {uid: 'player1', pub0: 'campaign2'} }
  let(:invalid_attributes) { {uid: nil} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OffersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    before :each do
      stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
        .with(query: hash_including(pub0: 'campaign2', uid: 'player1'))
        .to_return(
          status: 200,
          body: File.read(Rails.root.join(*%w[spec fixtures files response])),
          headers: {})
    end

    it 'assigns the new OffersRequest to @offers_request with attributes from params' do
      get :index, {offers_request: valid_attributes}, valid_session
      expect(assigns(:offers_request)).to be_kind_of(OffersRequest)
      expect(assigns(:offers_request).uid).to eq 'player1'
    end

    describe "with valid params" do
      it 'sends :fetch! to the @offers_request' do
        expect_any_instance_of(OffersRequest).to receive(:fetch!) {[]}
        get :index, {offers_request: valid_attributes}, valid_session
      end

      it 'assigns the offers as @offers' do
        get :index, {offers_request: valid_attributes}, valid_session
        expect(assigns(:offers)).to be_an(Array)
        expect(assigns(:offers).first).to be_an(Offer)
      end
    end   # with valid params

    describe "with invalid params" do
      it 'does not send :fetch! to the @offers_request' do
        expect_any_instance_of(OffersRequest).not_to receive(:fetch!) {[]}
        get :index, {offers_request: invalid_attributes}, valid_session
      end

      it 'assigns nil to @offers' do
        get :index, {offers_request: invalid_attributes}, valid_session
        expect(assigns(:offers)).to be nil
      end
    end   # with invalid params
  end   # GET index
end
