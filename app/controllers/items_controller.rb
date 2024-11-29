class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = current_user.items.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
  end

  def edit
  end
end
