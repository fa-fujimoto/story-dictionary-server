class VersionSerializer < ApplicationSerializer
  attributes :item_type, :item_id, :event, :whodunnit, :object
end