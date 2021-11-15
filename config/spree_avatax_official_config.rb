# frozen_string_literal: true

Rails.application.config.spree = Spree::Core::Environment.new
Rails.application.config.spree.calculators.tax_rates = [SpreeAvataxOfficial::Calculator::AvataxTransactionCalculator]
