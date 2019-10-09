module SpreeAvataxOfficial
  class EntityUseCode < ActiveRecord::Base
    with_options presence: true do
      validates :code, :name
    end
  end
end
