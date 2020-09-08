class AttributeValueSerializer < ApplicationSerializer
  attributes :name, :value, :kind, :required, :visible
  attribute :options, if: -> { ['select', 'boolean'].include?(kind) }
  attribute :custom_folder_term_id, if: :post_custom?

  def name
    object.item.name
  end

  def value
    object.value
  end

  def kind
    object.item.kind
  end

  def required
    object.item.required
  end

  def visible
    object.visible?
  end

  def custom_folder_term_id
    object.item.custom_folder.term_id
  end

  def post_custom?
    object.item.post_custom?
  end
end
