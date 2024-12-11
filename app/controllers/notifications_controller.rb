class NotificationsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_notifications, only: [:edit, :update]

    def edit
        set_notifications
    end

    def update
        set_notifications
        if @notification.update(notification_params)
            @notification.notification_update_next_notification_day(@notification.next_notification_day)
            redirect_to items_path, notice: '通知日を更新しました'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def set_notifications
        Rails.logger.debug "Params ID: #{params[:id]}"
        @notification = Notification.joins(:item)
                                    .find_by(id: params[:id], items: { user_id: current_user.id })
        Rails.logger.debug "@notification: #{@notification.inspect}"
        if @notification.nil?
            Rails.logger.debug "Notification not found for ID: #{params[:id]}"
            redirect_to items_path, alert: "通知が見つかりません"
        end
    end

    def notification_params
        params.require(:notification).permit(:next_notification_day, :last_notification_day, notification_interval)
    end
end
