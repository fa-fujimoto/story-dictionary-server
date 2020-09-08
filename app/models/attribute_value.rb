class AttributeValue < ApplicationRecord
  enum is_visible: { visible: true, invisible: false }
  PARAMS_LENGTH = Settings.model.params_length.attribute

  belongs_to :item, class_name: 'AttributeItem', foreign_key: 'attribute_item_id', inverse_of: 'values'
  belongs_to :post, touch: true

  validates :post, uniqueness: { scope: :attribute_item_id }
  validates :is_visible,
    inclusion: { in: AttributeValue.is_visibles.keys }

  validates :string,
    presence: { if: -> (value) { value.item.required && value.item.string_type? } },
    absence: { unless: -> (value) { value.item.string_type? } },
    exclusion: { in: [nil], if: -> (value) { value.item.string_type? } }
  validates :string,
    length: {
      in: 1..PARAMS_LENGTH.string.max
    },
    allow_blank: { if: -> (value) { !value.item.required && value.item.string_type? } }

  validates :integer,
    presence: { if: -> (value) { value.item.required && value.item.integer_type? } },
    absence: { unless: -> (value) { value.item.integer_type? } },
    exclusion: { in: [nil], if: -> (value) { value.item.integer_type? } }
  validates :integer,
    numericality: {
      only_integer: true
    },
    allow_blank: { if: -> (value) { !value.item.required && value.item.integer_type? } }

  validates :text,
    presence: { if: -> (value) { value.item.required && value.item.text_type? } },
    absence: { unless: -> (value) { value.item.text_type? } },
    exclusion: { in: [nil], if: -> (value) { value.item.text_type? } }
  validates :text,
    length: {
      in: PARAMS_LENGTH.text.min..PARAMS_LENGTH.text.max
    },
    allow_blank: { if: -> (value) { !value.item.required && value.item.text_type? } }

  validates :markdown,
    presence: { if: -> (value) { value.item.required && value.item.markdown_type? } },
    absence: { unless: -> (value) { value.item.markdown_type? } },
    exclusion: { in: [nil], if: -> (value) { value.item.markdown_type? } }
  validates :markdown,
    length: {
      in: PARAMS_LENGTH.text.min..PARAMS_LENGTH.text.max
    },
    allow_blank: { if: -> (value) { !value.item.required && value.item.markdown_type? } }

  validates :boolean,
    inclusion: { in: [true, false], if: -> (value) { value.item.boolean_type? } }
  validates :boolean,
    inclusion: { in: [nil], unless: -> (value) { value.item.boolean_type? } }

  validates :selected,
    absence: { unless: -> (value) { value.item.select_type? } },
    exclusion: { in: [nil], if: -> (value) { value.item.select_type? } }
  validates :selected,
    numericality: {
      only_integer: true
    },
    allow_nil: { if: -> (value) { !value.item.required && value.item.select_type? } }

  validates :selected,
    numericality: {
      greater_than_or_equal_to: 0
    },
    if: -> (value) { value.item.required && value.item.select_type? }
  validates :selected,
    numericality: {
      greater_than_or_equal_to: -1
    },
    if: -> (value) { !value.item.required && value.item.select_type? }

  validate :selected_value_exist_options
  validate do
    if post && !post.setable_attribute?(item)
      errors.add(:base, :invalid)
    end
  end

  scope :has_value, -> { where.not(string: [nil, '']).or(where.not(integer: nil)).or(where.not(text: [nil, ''])).or(where.not(markdown: [nil, ''])).or(where.not(boolean: nil)) }

  scope :visible_for, -> (post_type) { visible.joins(:item).includes(:item).merge(AttributeItem.visible.where(post_type: post_type)) }

  def value
    if item.text_type?
      text
    elsif item.markdown_type?
      markdown
    elsif item.string_type?
      string
    elsif item.integer_type?
      integer
    elsif item.boolean_type?
      boolean
    elsif item.select_type?
      selected
    end
  end

  def value=(new_value)
    if item.text_type?
      self.text = new_value
    elsif item.markdown_type?
      self.markdown = new_value
    elsif item.string_type?
      self.string = new_value
    elsif item.integer_type?
      self.integer = new_value
    elsif item.boolean_type?
      self.boolean = new_value
    elsif item.select_type?
      self.selected = new_value
    end
  end

  private
  def selected_value_exist_options
    errors.add(:selected, :invalid) if selected.present? && selected != -1 && !item.settable_select_value_is?(selected)
  end
end