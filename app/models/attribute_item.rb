class AttributeItem < ApplicationRecord
  enum post_type: {
    word: 0,
    character: 1,
    group: 2,
    custom: 99
  }, _prefix: :post
  enum kind: {
    string: 0,
    integer: 1,
    text: 2,
    markdown: 3,
    boolean: 4,
    select: 5
  }, _suffix: :type

  has_many :values, class_name: 'AttributeValue', foreign_key: 'attribute_value_id', inverse_of: 'item'
  has_many :posts, through: :values

  has_many :project_configs, class_name: 'AttributeConfig', inverse_of: 'item'
  has_many :projects, through: :project_configs

  has_many :options, class_name: 'AttributeOption', inverse_of: 'item', dependent: :destroy

  belongs_to :custom_folder, optional: true

  validates :name,
    presence: true,
    length: { minimum: 1, maximum: 100 }
  validates :post_type,
    inclusion: { in: AttributeItem.post_types.keys }
  validates :kind,
    inclusion: { in: AttributeItem.kinds.keys }
  validates :required, :default_item, inclusion: { in: [true, false] }
  validates :options,
    length: { is: 2 },
    if: :boolean_type?,
    on: :update
  validates :options,
    presence: { if: :options_settable? },
    on: :update
  validates :options, absence: { unless: :options_settable? }
  validates :custom_folder_id,
    presence: { if: -> (item) { item.post_custom? } },
    absence: { unless: -> (item) { item.post_custom? } }

  scope :belong_to_word, -> { where(post_type: :word) }
  scope :belong_to_character, -> { where(post_type: :character) }
  scope :belong_to_custom_as, -> (name) { joins(:custom_folder).merge(CustomFolder.term_is name) }
  scope :visible, -> { joins(:project_configs).merge(AttributeConfig.visible) }

  def setable_name_for?(project)
    project && !project.attribute_items.exists?(name: name, post_type: post_type)
  end

  def settable_select_value_is?(value)
    select_type? && options.exists?(value: value)
  end

  def options_settable?
    boolean_type? || select_type?
  end
end
