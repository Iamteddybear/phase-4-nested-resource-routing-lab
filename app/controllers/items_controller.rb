# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :set_user

  # GET /users/:user_id/items
  def index
    if @user
      items = @user.items
      render json: items, include: :user
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # GET /users/:user_id/items/:id
  def show
    item = find_item

    if item
      render json: item, include: :user
    else
      render json: { error: 'Item not found' }, status: :not_found
    end
  end

  # POST /users/:user_id/items
  def create
    if @user
      item = @user.items.build(item_params)

      if item.save
        render json: item, status: :created, include: :user
      else
        render json: { error: item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def find_item
    @user&.items&.find_by(id: params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
end
