require 'rails_helper'

describe "offers/index", type: :view do
  before(:each) do
    assign(:offers, [
      # if you got an exception here add gem 'rspec-activemodel-mocks' to your Gemfile
      Offer.new(
        'title' => 'Title',
        'thumbnail' => 'Thumbnail',
        'payout' => 'Payout'
      ),
      Offer.new(
        'title' => 'Title',
        'thumbnail' => 'Thumbnail',
        'payout' => 'Payout'
      ),
    ])
    assign(:offers_request, OffersRequest.new)
  end

  it "renders a list of offers" do
    render

    assert_select "tr>td>img", src: "Thumbnail".to_s, count: 2
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Payout".to_s, count: 2
  end

  it "renders the offers_request form" do
    render

    assert_select "form[action='#{offers_path(@offers_request)}'][method='get']" do
      assert_select 'input#offers_request_uid[name=?]', 'offers_request[uid]'
      assert_select 'input#offers_request_pub0[name=?]', 'offers_request[pub0]'
      assert_select 'select#offers_request_page[name=?]', 'offers_request[page]'
      assert_select 'input#offers_request_pages[name=?]', 'offers_request[pages]'
    end
  end
end
