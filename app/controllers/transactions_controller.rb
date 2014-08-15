class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_braintree_data, only: [:show, :edit]

  def show
  end

  def new
    gon.client_token = generate_new_client_token
  end

  def edit
    @credit_card = current_user.default_credit_card
    @tr_data = edit_customer_tr_data
  end

  def create
    @result = Braintree::Transaction.sale(
              amount: current_user.cart_total_price,
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      current_user.purchase_cart_movies!
      redirect_to root_url, notice: "Congraulations! You've purchased new movies successfully!"
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_new_client_token
      render :new
    end
  end

  private

  def generate_new_client_token
    Braintree::ClientToken.generate
  end

end
