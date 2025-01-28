module ApplicationHelper
    def default_meta_tags
        {
            site: "StockMate",
            title: "日用品の補充時期を通知してくれるサービス",
            reverse: true,
            charset: "utf-8",
            description: "",
            keywords: "日用品,LINE",
            canonical: request.original_url,
            separator: "|",
            og: {
                site_name: site,
                title: :title,
                description: :description,
                type: "website",
                url: request.original_url,
                image: image_url("画像"),
                local: "ja-JP",
            },

            twitter: {
                card: "summary_large_image",
                site: "@",
                image: image_url("画像")
            }
        }
    end
end
