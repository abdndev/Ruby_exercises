require './lib/shipment'

describe Shipment do
  it 'should work without options' do
    expect(Shipment.total_weight).to eq(29)
  end
end

