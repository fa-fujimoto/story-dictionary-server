class AttributeConfig < ApplicationRecord
  before_validation :set_default_value

  enum is_visible: { visible: true, invisible: false }
  belongs_to :project
  belongs_to :item, class_name: 'AttributeItem', foreign_key: 'attribute_item_id', inverse_of: 'project_configs'

  include RankedModel
  ranks :option_order

  validates :item, uniqueness: { scope: :project_id }
  validates :is_visible,
    inclusion: { in: AttributeConfig.is_visibles.keys }
  validate :check_item_name

  scope :visible_to, -> post_type {
    case post_type
    when 'word'
      visible_to_word
    when 'character'
      visible_to_character
    else
      all
    end
  }

  scope :visible_to_word, -> {
    joins(:item).merge(AttributeItem.belong_to_word).visible
  }

  scope :visible_to_character, -> {
    joins(:item).merge(AttributeItem.belong_to_character).visible
  }

  scope :visible_to_custom_as, -> term_id {
    joins(:item).merge(AttributeItem.belong_to_custom_as term_id).visible
  }

  def check_item_name
    if item && !item.setable_name_for?(project)
      errors.add(:base, :invalid)
    end
  end

  private
  def set_default_value
    self.is_visible = 'visible'
  end
end
