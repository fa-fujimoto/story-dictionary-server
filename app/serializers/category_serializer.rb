class CategorySerializer < ApplicationSerializer
  attributes :id, :name, :synopsis, :body
  has_one :project
end
