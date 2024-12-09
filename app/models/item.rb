class Item < ApplicationRecord
    belongs_to :user
    has_one :notification, dependent: :destroy

    validates :category, presence: true
    validates :name, presence: true, length: { maximum: 255 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :used_count_per_day, presence: true, numericality: { other_than: 0 }
    validates :memo, length: { maximum: 65_535 }, allow_nil: true

    # 一回の平均使用量
    AVERAGE_USAGE = {
        "shampoo" => 6,
        "body_soap" => 6,
        "laundry_detergent_powder" => 17,
        "laundry_detergent_liquid" => 8,
        "fabric_softener" => 20,
        "dishwashing_detergent" => 4,
        "lotion" => 5,
        "serum" => 2.5,
        "moisturizer" => 1.5,
        "face_wash" => 1,
        "sunscreen" => 0.9
    }

    def calculate_next_notification_day
        # 一日の平均使用量
        average_daily_usage = AVERAGE_USAGE[self.category] || 0
        # 一日の使用量
        daily_usage = average_daily_usage * self.used_count_per_day

        # 通知日の算出
        days = 0
        while true
            reminding_volume = self.volume - (daily_usage * days)
            if reminding_volume <= (self.volume * 1.0 / 3 )
                break
            else
                days += 1
            end
        end
        Date.today + days
    end
end
