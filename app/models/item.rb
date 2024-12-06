class Item < ApplicationRecord
    belongs_to :user

    validates :category, presence: true
    validates :name, presence: true, length: { maximum: 255 }
    validates :volume, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :used_count_per_day, presence: true, numericality: { only_integer: true, other_than: 0 }
    validates :memo, length: { maximum: 65_535 }, allow_nil: true

    CATEGORY_NAMES = {
        "shampoo" => "シャンプー",
        "body_soap" => "ボディソープ",
        "laundry_detergent_powder" => "洗濯用洗剤(粉)",
        "laundry_detergent_liquid" => "洗濯用洗剤(液)",
        "fabric_softeners" => "柔軟剤",
        "dishwashing_detergent" => "食器用洗剤",
        "lotion" => "化粧水",
        "serum" => "美容液",
        "moisturising_cream" => "保湿クリーム",
        "face_wash" => "洗顔料",
        "sunscreen" => "日焼け止め",
        "others" => "その他" 
    }.freeze

    def category_name
        CATEGORY_NAMES[self.category]
    end
end
