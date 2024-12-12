class NotificationsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_notification, only: [:edit, :update]

    def edit
    end

    def update
        if @notification.update(notification_params)
            @notification.notification_update_next_notification_day(@notification.next_notification_day)
            redirect_to items_path, notice: '通知日を更新しました'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_notification
        @notification = Notification.find(params[:id])
        if @notification.nil?
            redirect_to items_path, alert: "通知が見つかりません"
        end
    end

    def notification_params
        params.require(:notification).permit(:next_notification_day, :last_notification_day, :notification_interval)
    end
end
