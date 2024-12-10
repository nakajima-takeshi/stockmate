class NotificationsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_notifications, only: [:edit, :update]

    def edit; end

    def update
        set_notifications
        if @notification.update(notification_params)
            @notification.update_next_notification_day
            redirect_to items_path, notice: '通知日を更新しました'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_notifications
        @notification = current_user.items
        .joins(:notification)
        .find(params[:id])
        .notification
    end

    def notification_params
        params.require(:notification).permit(:next_notification_day)
    end
end
