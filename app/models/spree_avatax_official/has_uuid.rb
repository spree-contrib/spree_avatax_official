module SpreeAvataxOfficial
  module HasUuid
    AVATAX_CODES = {
      'LineItem' => 'LI',
      'Shipment' => 'FR'
    }.freeze

    def self.included(base)
      base.before_create :generate_uuid
    end

    def avatax_number
      "#{AVATAX_CODES[self.class.name.demodulize]}-#{avatax_uuid}"
    end

    private

    def generate_uuid
      self.avatax_uuid = SecureRandom.uuid if avatax_uuid.blank?
    end
  end
end
