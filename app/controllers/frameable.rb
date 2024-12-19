module Frameable
    extend ActiveSupport::Concern

    private

    # リクエストがTurboフレーム経由かどうかを判定
    def ensure_turbo_frame_response
        redirect_to items_path unless turbo_frame_request?
    end
end
