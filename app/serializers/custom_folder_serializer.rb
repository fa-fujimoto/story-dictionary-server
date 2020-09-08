class CustomFolderSerializer < ApplicationSerializer
  attributes :term_id, :name
  has_one :project
end
