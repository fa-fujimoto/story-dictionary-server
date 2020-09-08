class AccountSerializer < ApplicationSerializer
  attributes :id, :name, :nickname, :allow_password_change, :image, :created_at, :updated_at
end
