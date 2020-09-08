class Admin::Base < ApplicationController
  before_action :login_required
  before_action :set_account

  private
  def login_required
    raise Forbidden unless current_user
  end

  def set_account
    @account = current_user
  end
end
