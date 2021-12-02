# frozen_string_literal: true

require_relative '../app/models/spree_avatax_official/configuration'
require_relative '../app/models/spree_avatax_official/calculator/avatax_transaction_calculator'

Rails.application.config.spree = Spree::Core::Environment.new
SpreeAvataxOfficial::Config    = SpreeAvataxOfficial::Configuration.new
