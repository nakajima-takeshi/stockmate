module ApplicationHelper
    def default_meta_tags
        {
            site: "StockMate",
            title: "日用品の補充時期を通知してくれるサービス",
            reverse: true,
            charset: "utf-8",
            description: "登録した日用品の消耗具合を予測し、残量が少なくなったタイミングでLINEに通知してくれます",
            keywords: "日用品,LINE",
            canonical: request.original_url,
            separator: "|",
            icon: [
                {href: image_url("favicon.ico")},
            ],
            og: {
                site_name: :site,
                title: :title,
                description: :description,
                type: "website",
                url: request.original_url,
                image: image_url("stockmate_top_image.png"),
                local: "ja-JP",
            },

            twitter: {
                card: "summary_large_image",
                site: "@",
                image: image_url("stockmate_top_image.png")
            }
        }
    end
end
