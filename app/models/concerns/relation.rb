module Relation
  extend ActiveSupport::Concern

  included do
    validates :from_id, uniqueness: { scope: :to_id }
    validates :description, length: { in: 1..30 }, allow_blank: true
    validates :detail, length: { in: 1..10000 }, allow_blank: true
  end
end