class BaseSerializer < ActiveModel::Serializer
  def created_at
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S%z")
  end

  def updated_at
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S%z")
  end
end
