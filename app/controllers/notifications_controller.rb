class NotificationsController < ApplicationController
    include Frameable

    before_action :authenticate_user!
    before_action :ensure_turbo_frame_response, only: %w[edit]
    before_action :set_notification, only: [ :edit, :update ]

    def edit; end

    def update
        if @notification.update(notification_params)
            @notification.notification_update_next_notification_day(@notification.next_notification_day)
            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: turbo_stream.update(
                        "notification_#{@notification.id}",
                        partial: "notifications/notification",
                        locals: { notification: @notification }
                        )
                end
                format.html { redirect_to items_path, notice: "通知予定日を更新しました" }
            end
        else
            respond_to do |format|
                format.html { render :edit, status: :unprocessable_entity }
            end
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
