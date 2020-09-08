class Admin::AccountsController < Admin::Base
  # GET /account
  def show
    render json: @account, serializer: AccountSerializer
  end

  # PATCH/PUT /account
  def update
    if @account.update(account_params)
      render json: @account, serializer: AccountSerializer
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def account_params
      params.require(:account).permit(:nickname)
    end
end
