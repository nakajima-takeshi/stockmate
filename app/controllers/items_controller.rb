class ItemsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_item, only: [ :show, :edit, :update ]

  def index
    @items = current_user.items.includes(:user).order(created_at: :desc)
  end

  def show
    @notification = current_user.items.joins(:notification).find(params[:id]).notification
  end

  def new
    @item = current_user.items.build
  end

  def create
    ActiveRecord::Base.transaction do
      @item = current_user.items.build(item_params)
      if @item.save
        next_notification_day = @item.calculate_next_notification_day
        notification_interval = @item.calculate_interval(next_notification_day)
        @item.create_notification(
          next_notification_day: next_notification_day,
          notification_interval: notification_interval
          )
          redirect_to items_path, notice: "新たに日用品を登録しました"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update
    registered_volume = @item.volume
    registered_used_count_per_day = @item.used_count_per_day

    if @item.update(item_params)
      if registered_volume != @item.volume || registered_used_count_per_day != @item.used_count_per_day
        @item.notification.item_update_next_notification_day
      end
        redirect_to items_path, notice: "登録内容を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.destroy
      redirect_to items_path, notice: "日用品を削除しました"
    else
      redirect_to items_path, alert: "削除に失敗しました"
    end
  end

  private

  def set_item
    @item = current_user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:category, :name, :volume, :used_count_per_day, :memo)
  end
end
