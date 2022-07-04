class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      items = user.items
      return render json: items, include: :user
    else
      items = Item.all
      return render json: items, include: :user
    end
  end

  def show
    item = Item.find_by!(id: params[:id])
    render json: item, include: :user
  end

  def create
    user = User.find_by!(id: params[:user_id])
    item =  user.items.create(name: params[:name], description: params[:description], price: params[:price])
    render json: item, status: :created
  end

  private

  def user_not_found
    render json: {error: "User not found"}, status: :not_found
  end

end
