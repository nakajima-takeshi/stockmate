class Item < ApplicationRecord
    belongs_to :user

    validates :name, presence: true, length: { maximum: 255 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :used_count_per_day, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :memo, length: { maximum: 65_535 }, allow_nil: true
end
