class ItemsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_item, only: [ :show, :edit, :update, :destroy ]

  def index
    @items = current_user.items.includes(:user).order(created_at: :desc)
  end

  def show
    set_item
  end

  def new
    @item = current_user.items.build
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      # オブジェクトを初期化
      @item.create_notification(
        next_notification_day: @item.calculate_next_notification_day
        )
      redirect_to items_path, notice: "新たに日用品を登録しました"
    else
      render :new, status: :unprocessable_entity # エラーメッセージ表示
    end
  end

  def edit
    set_item
  end

  def update
    set_item
    if @item.update(item_params)
      @item.notification.update_next_notification_day
        redirect_to items_path(@item), notice: "登録内容を更新しました"
    else
      render :edit, status: :unprocessable_entity # エラーメッセージ表示
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
