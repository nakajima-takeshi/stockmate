class Item < ApplicationRecord
    belongs_to :user
    has_one :notification, dependent: :destroy

    validates :category, presence: true
    validates :name, presence: true, length: { maximum: 30 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    # 毎日使わない場合、初回は１と登録してもらった後にユーザーに手動で調整してもらう
    validates :used_count_per_day, presence: true, numericality: { only_integer: true, other_than: 0 }
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
        "sunscreen" => 0.9,
        "others" => 10
    }

    def calculate_next_notification_day
        if self.category == "others"
            Date.today + 14.days
        else
            # 一回の平均使用量
            average_usage = AVERAGE_USAGE[self.category] || 0
            # 一日の使用量
            daily_usage = average_usage * self.used_count_per_day

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
        message = "#{self.name}の残量が少なくなっています\n"
        message += " メモ: #{self.memo}\n" if self.memo.present?
        message += "https://stockmate-a7c103b7b0ba.herokuapp.com/\n"
        message
    end
end
