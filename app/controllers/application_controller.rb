class ApplicationController < ActionController::API
  before_action :set_paper_trail_whodunnit
  # skip_before_action :verify_authenticity_token, if: :devise_controller?
  include DeviseTokenAuth::Concerns::SetUserByToken

  class Forbidden < StandardError; end

  def user_for_paper_trail
    current_user ? current_user.name : 'Guest'
  end
end
