require 'spec_helper'

describe Staccato::Measurement::Item do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  context 'a pageview with a transaction and a transaction item' do
    let(:pageview) {
      tracker.build_pageview({
        path: '/receipt', hostname: 'mystore.com',
        title: 'Your Receipt', product_action: 'purchase'
      })
    }

    let(:transaction_measurement_options) {{
      transaction_id: 'T12345',
      affiliation: 'Your Store',
      revenue: 37.39,
      tax: 2.85,
      shipping: 5.34,
      currency: 'USD',
      coupon_code: 'SUMMERSALE'
    }}

    let(:item_measurement_options) {{
      name: 'T-Shirt',
      price: 14.60,
      quantity: 2,
      code: 'P12345',
      category: 'Apparel'
    }}

    before(:each) do
      pageview.add_measurement(:transaction, transaction_measurement_options)
      pageview.add_measurement(:item, item_measurement_options)

      pageview.track!
    end

    it 'tracks the measurement' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/receipt',
        'dt' => 'Your Receipt',
        'pa' => 'purchase',
        'ti' => 'T12345',
        'ta' => 'Your Store',
        'tr' => 37.39,
        'ts' => 5.34,
        'tt' => 2.85,
        'cu' => 'USD',
        'tcc' => 'SUMMERSALE',
        'in' => 'T-Shirt',
        'ip' => 14.60,
        'iq' => 2,
        'ic' => 'P12345',
        'iv' => 'Apparel'
      })
    end
  end
end
