class PostSerializer < ApplicationSerializer
  attributes :name, :term_id, :kana, :synopsis, :status
  has_one :project
  has_one :author
  has_one :last_editor
  has_many :attribute_values

  def attribute_values
    instance_options[:input_mode] ? object.attribute_values : object.visible_attribute_values
  end
end
