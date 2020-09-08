class AttributeItemsController < ApplicationController
  before_action :set_attribute_item, only: [:show, :update, :destroy]

  # GET /attribute_items
  def index
    @attribute_items = AttributeItem.all

    render json: @attribute_items
  end

  # GET /attribute_items/1
  def show
    render json: @attribute_item
  end

  # POST /attribute_items
  def create
    @attribute_item = AttributeItem.new(attribute_item_params)

    if @attribute_item.save
      render json: @attribute_item, status: :created, location: @attribute_item
    else
      render json: @attribute_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attribute_items/1
  def update
    if @attribute_item.update(attribute_item_params)
      render json: @attribute_item
    else
      render json: @attribute_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attribute_items/1
  def destroy
    @attribute_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute_item
      @attribute_item = AttributeItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def attribute_item_params
      params.require(:attribute_item).permit(:name, :type, :required)
    end
end
