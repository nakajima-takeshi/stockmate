class ItemsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_item, only: [ :show, :edit, :update ]

  def index
    @items = current_user.items.joins(:notification).includes(:user, :notification)

    case params[:sort]
    when "category"
      @items = @items.order_by_category
    when "updated_at"
      @items = @items.order_by_updated_at
    when "notification_date", nil
      @items = @items.order_by_notification_date_asc
    end
  end

  def show
    @notification = @item.notification
  end

  def new
    @item = current_user.items.build
  end

  def create
    ActiveRecord::Base.transaction do
      @item = current_user.items.build(item_params)

      if @item.valid?
        next_notification_day = @item.calculate_next_notification_day
        notification_interval = @item.calculate_interval(next_notification_day)

        @notification = @item.build_notification(
          next_notification_day: next_notification_day,
          notification_interval: notification_interval
        )
        if @notification.valid?
          @item.save!
          @notification.save!
          redirect_to items_path, notice: "新たに日用品を登録しました"
        else
          render :new, status: :unprocessable_entity
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update
    registered_volume = @item.volume
    registered_used_count_per_weekly = @item.used_count_per_weekly

    if @item.update(item_params)
      # 既存のデータと異なるかを比較
      if registered_volume != @item.volume || registered_used_count_per_weekly != @item.used_count_per_weekly
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
    params.require(:item).permit(:category, :name, :volume, :used_count_per_weekly, :memo)
  end
end
