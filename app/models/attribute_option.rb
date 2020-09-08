class AttributeOption < ApplicationRecord
  belongs_to :item, class_name: 'AttributeItem', foreign_key: 'attribute_item_id', inverse_of: 'options'

  validates :name,
    presence: true,
    length: { in: 1..30 },
    uniqueness: { scope: :attribute_item_id }

  validates :value,
    uniqueness: { scope: :attribute_item_id }

  with_options if: :belongs_to_boolean? do
    validates :value,
      numericality: {
        only_integer: true,
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 1
      }
  end

  with_options if: :belongs_to_select? do
    validates :value,
      numericality: {
        only_integer: true,
        greater_than_or_equal_to: 0,
      }
  end

  validate :options_count_must_be_within_limit, if: :belongs_to_boolean?
  validate do
    if item && !item.options_settable?
      errors.add(:base, :invalid)
    end
  end

  private
  def options_count_must_be_within_limit
    errors.add(:item_id, :invalid) if item.options.count > 2
  end

  def belongs_to_boolean?
    item && item.boolean_type?
  end

  def belongs_to_select?
    item && item.select_type?
  end
end
