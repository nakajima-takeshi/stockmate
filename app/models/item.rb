class Item < ApplicationRecord
    belongs_to :user
    has_one :notification, dependent: :destroy

    validates :category, presence: true
    validates :name, presence: true, length: { maximum: 30 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :used_count_per_weekly, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :memo, length: { maximum: 65_535 }, allow_nil: true

    AVERAGE_USAGE = {
        "shampoo" => 6,
        "body_soap" => 6,
        "laundry_detergent_powder" => 20,
        "laundry_detergent_liquid" => 25,
        "fabric_softener" => 25,
        "dishwashing_detergent" => 4,
        "lotion" => 5,
        "serum" => 3,
        "moisturizer" => 2,
        "face_wash" => 1,
        "sunscreen" => 2,
        "others" => 10
    }

    def calculate_next_notification_day
        if self.category == "others"
            Date.today + 14.days
        else
            average_usage = AVERAGE_USAGE[self.category] || 0
            used_count_per_weekly = self.used_count_per_weekly.to_i
            daily_usage = average_usage * ((used_count_per_weekly / 7.0).ceil(2))

            days = 0
            max_days = 365
            while days < max_days
                reminding_volume = self.volume - (daily_usage * days)
                if reminding_volume <= (self.volume * 1.0 / 3)
                    break
                else
                    days += 1
                end
            end
            Date.today + days
        end
    end

    def calculate_interval(next_notification_day)
        (next_notification_day - Date.today).to_i
    end

    def create_notification_message
        message = "#{self.name}の在庫補充をしてください\n"
        message += "メモ書きがあります。メモ内容 : #{self.memo}\n" if self.memo.present?
        message += "https://stockmate.dev/\n"
        message
    end
end
