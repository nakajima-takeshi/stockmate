class Item < ApplicationRecord
    belongs_to :user
    has_one :notification, dependent: :destroy

    validates :category, presence: true
    validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 30 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :used_count_per_weekly, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :memo, length: { maximum: 65_535 }, allow_nil: true

    AVERAGE_USAGE = {
        "shampoo" => 6,
        "body_soap" => 6,
        "laundry_detergent_powder" => 20,
        "laundry_detergent_liquid" => 25,
        "fabric_softeners" => 25,
        "dishwashing_detergent" => 4,
        "lotion" => 5,
        "serum" => 3,
        "moisturising_cream" => 2,
        "face_wash" => 1,
        "sunscreen" => 2,
        "others" => 10
    }

    def calculate_next_notification_day
        if self.category == "others"
            return Date.today + 14.days
        end

        daily_usage = calculate_daily_usage
        notification_volume = (self.volume * 1.0 / 3).ceil(2)

        days = 0
        max_days = 365
        while days < max_days
            reminding_volume = self.volume - (daily_usage * days)
            if reminding_volume <= notification_volume
                break
            else
                days += 1
            end
        end
        # 日付を返す
        Date.today + days
    end

    def calculate_interval(next_notification_day)
        (next_notification_day - Date.today).to_i
    end

    def line_calculate_next_notification_day
        if self.category == "others"
            return 14
        end

        daily_usage = calculate_daily_usage
        notification_volume = (self.volume * 1.0 / 3).ceil(2)
        total_volume = notification_volume + self.volume

        days = 0
        max_days = 365
        while days < max_days
            reminding_volume = total_volume - (daily_usage * days)
            if reminding_volume <= notification_volume
                break
            else
                days += 1
            end
        end
        # 日数を返す
        days
    end

    private

    def calculate_daily_usage
        average_usage = AVERAGE_USAGE[self.category] || 0
        used_count_per_weekly = self.used_count_per_weekly.to_i
        average_usage * ((used_count_per_weekly / 7.0).ceil(2))
    end
end
