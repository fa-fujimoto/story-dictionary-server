class AccountsController < ApplicationController
  before_action :set_account
  # GET /account
  def show
    if @account
      render json: @account, serializer: AccountSerializer
    else
      render json: @account
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def account_params
      params.require(:account).permit(:nickname)
    end

    def set_account
      @account = current_user
    end
end
