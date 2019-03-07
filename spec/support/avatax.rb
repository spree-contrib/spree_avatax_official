AvaTax.configure do |config|
  config.endpoint = 'https://sandbox-rest.avatax.com'
end

# Avatax API endpoints use this value as url parameter, thus it's required for VCR cassetes
SpreeAvataxOfficial::Config.company_code      = 'test1'
SpreeAvataxOfficial::Config.ship_from_address = {
  line1:      '822 Reed St',
  line2:      '',
  city:       'Philadelphia',
  region:     'PA',
  country:    'USA',
  postalCode: '19147'
}

# Added temporarily for a project with multiple namespaces
Spree::Order.prepend ::SpreeAvataxOfficial::Spree::OrderDecorator
Spree::Address.prepend ::SpreeAvataxOfficial::Spree::AddressDecorator
Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
Spree::OrderUpdater.prepend ::SpreeAvataxOfficial::Spree::OrderUpdaterDecorator
Spree::Refund.prepend(::SpreeAvataxOfficial::Spree::RefundDecorator) if 'Spree::Refund'.safe_constantize
