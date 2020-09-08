class CustomPost < ApplicationRecord
  belongs_to :post, inverse_of: 'custom'
end
