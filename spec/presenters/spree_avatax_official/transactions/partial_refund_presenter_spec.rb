require 'spec_helper'

describe SpreeAvataxOfficial::Transactions::PartialRefundPresenter do
  subject do
    described_class.new(
      order:        order,
      refund_items: { line_item => [quantity, amount] }
    )
  end

  let(:ship_from_address) { SpreeAvataxOfficial::Config.ship_from_address }
  let(:result) do
    {
      type:          'ReturnInvoice',
      companyCode:   SpreeAvataxOfficial::Configuration.new.company_code,
      referenceCode: order.number,
      code:          nil,
      date:          order.updated_at.strftime('%Y-%m-%d'),
      customerCode:  order.email,
      addresses:     SpreeAvataxOfficial::AddressPresenter.new(address: ship_from_address, address_type: 'ShipFrom').to_json.merge(
        SpreeAvataxOfficial::AddressPresenter.new(address: order.ship_address, address_type: 'ShipTo').to_json
      ),
      lines:         [SpreeAvataxOfficial::ItemPresenter.new(item: line_item, custom_quantity: quantity, custom_amount: amount).to_json],
      commit:        false,
      discount:      0.0
    }
  end

  let(:order)     { create(:order_with_line_items) }
  let(:line_item) { order.line_items.first }
  let(:quantity)  { line_item.quantity - 1 }
  let(:amount)    { line_item.amount * 2 }

  it 'serializes the object' do
    expect(subject.to_json).to eq result
  end
end
