module SpreeAvataxOfficial
  module HasUuid
    AVATAX_CODES = {
      'Spree::LineItem' => 'LI',
      'Spree::Shipment' => 'FR'
    }.freeze

    def self.included(base)
      base.before_create :generate_uuid
    end

    def avatax_number
      "#{AVATAX_CODES[self.class.to_s]}-#{avatax_uuid}"
    end

    private

    def generate_uuid
      self.avatax_uuid = SecureRandom.uuid if avatax_uuid.blank?
    end
  end
end
