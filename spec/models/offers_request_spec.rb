require 'rails_helper'

describe OffersRequest, type: :model do

  subject {OffersRequest.new uid: 'player1', pub0: 'campaign2'}

  it {should be_valid}
  it {should validate_presence_of :uid}
  it {should validate_presence_of :pub0}
  it {should validate_numericality_of(:page).is_less_than_or_equal_to 1}
  # it {should validate_numericality_of(:pages)}

  describe '#initialize' do
    it 'intilizes :uid' do
      expect(subject.uid).to eq 'player1'
    end

    it 'intilizes :pub0' do
      expect(subject.pub0).to eq 'campaign2'
    end

    it 'intilizes :page' do
      expect(subject.page).to eq 0
    end

    it 'intilizes :pages keeping it >= 1' do
      expect(subject.pages).to eq 1
    end
  end   #initialize

  describe '#attributes' do
    it 'returns a Hash with the following keys: :uid, :pub0, :page' do
      expect(subject.attributes).to be_a Hash
      expect(subject.attributes.keys).to eq [:uid, :pub0, :page]
    end
  end   #attributes

  describe '#fetch!' do
    context 'when OffersRequest.get is successful' do
      before :each do
        stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
          .with(query: hash_including(pub0: 'campaign2', uid: 'player1'))
          .to_return(
            status: 200,
            body: File.read(Rails.root.join(*%w[spec fixtures files response])),
            headers: {})
      end

      it 'returns an Array of Offers if success' do
        expect(subject.fetch!).to be_an Array
        expect(subject.fetch!.first).to be_an Offer
      end

      it 'assings :pages to itself' do
        subject.fetch!
        expect(subject.pages).to eq 2
      end

      it 'assings :qty to itself' do
        subject.fetch!
        expect(subject.qty).to eq 2
      end
    end   # when OffersRequest.get is successful

    context 'when OffersRequest.get is not successful' do
      before :each do
        stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
          .with(query: hash_including(pub0: 'campaign2', uid: 'player1'))
          .to_return(
            status: 400,
            body: File.read(Rails.root.join(*%w[spec fixtures files response])),
            headers: {})
      end

      it 'returns the string' do
        expect(subject.fetch!).to be_an String
      end
    end   # when OffersRequest.get is not successful
  end   #fetch!

  describe :class do
    describe '.get' do
      context 'with correct params' do
        before :each do
          stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
            .with(query: hash_including(pub0: 'campaign2', uid: 'player1'))
            .to_return(
              status: 200,
              body: File.read(Rails.root.join(*%w[spec fixtures files response])),
              headers: {})
        end

        it 'returns a Hash' do
          expect(OffersRequest.get uid: 'player1', pub0: 'campaign2', page: 1)
            .to be_an Hash
        end

        describe 'the returned hash' do
          it 'has the keys %w[code count offers page]' do
            expect(OffersRequest.get(uid: 'player1', pub0: 'campaign2', page: 1).keys.sort)
              .to eq %w[code count offers pages]
          end

          it 'has an Array in "offers" key' do
            expect(OffersRequest.get(uid: 'player1', pub0: 'campaign2', page: 1)['offers'])
              .to be_an Array
          end
        end   # the returned hash
      end   # with correct params

      context 'with incorrect params' do
        context 'when response body is blank' do
          before :each do
            stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
              .with(query: hash_including(pub0: 'campaign2'))
              .to_return(
                status: 400,
                body: '',
                headers: {})
          end

          it 'returns a String with response status' do
            expect(OffersRequest.get pub0: 'campaign2', page: 1)
                .to eq 'Bad response is received: Net::HTTPBadRequest'
          end
        end   # when response body is blank

        context 'when response body is not blank' do
          context 'and is valid json' do
            context 'containing "code" key' do
              before :each do
                stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
                  .with(query: hash_including(pub0: 'campaign2'))
                  .to_return(
                    status: 400,
                    body: '{"code":"ERROR_INVALID_PAGE"}',
                    headers: {})
              end

              it 'returns a String with response status' do
                expect(OffersRequest.get pub0: 'campaign2', page: 1)
                    .to eq 'Bad response is received: ERROR_INVALID_PAGE'
              end
            end   # containing "code" key

            context 'not containing "code" key' do
              before :each do
                stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
                  .with(query: hash_including(pub0: 'campaign2'))
                  .to_return(
                    status: 400,
                    body: '{}',
                    headers: {})
              end

              it 'returns a String with response status' do
                expect(OffersRequest.get pub0: 'campaign2', page: 1)
                    .to eq 'Bad response is received: Net::HTTPBadRequest'
              end
            end   # not containing "code" key
          end   # and is valid json

          context 'and is invalid json' do
            before :each do
              stub_request(:get, 'http://api.fyber.com/feed/v1/offers.json')
                .with(query: hash_including(pub0: 'campaign2'))
                .to_return(
                  status: 400,
                  body: 'zzzz',
                  headers: {})
            end

            it 'returns a String with response status' do
              expect(OffersRequest.get pub0: 'campaign2', page: 1)
                  .to eq 'Bad response is received: Net::HTTPBadRequest'
            end
          end   # and is invalid json
        end   # when response body is not blank
      end   # with incorrect params
    end   # .get

    describe :private do
      describe '.add_hashkey' do
        let(:params) do
          {
            appid: 157,
            uid: 'player1',
            ip: '212.45.111.17',
            locale: :de,
            device_id: '2b6f0cc904d137be2e1730235f5664094b831186',
            ps_time: 1312211903,
            pub0: 'campaign2',
            page: 2,
            timestamp: 1312553361
          }
        end
        it 'returns a Hash' do
          expect(OffersRequest.send :add_hashkey, params).to be_a Hash
        end

        it 'sorts the keys' do
          expect(OffersRequest.send(:add_hashkey, params).keys.second).to eq :device_id
        end

        it 'adds the key :hashkey to the end' do
          expect(OffersRequest.send(:add_hashkey, params).keys.last).to eq :hashkey
        end

        it 'calculates the correct :hashkey value' do
          expect(Rails.application.secrets).to receive(:[]).with(:api_key)
            .and_return('e95a21621a1865bcbae3bee89c4d4f84')
          expect(OffersRequest.send(:add_hashkey, params)[:hashkey])
            .to eq '7a2b1604c03d46eec1ecd4a686787b75dd693c4d'
        end
      end
    end   # private
  end   # class
end
