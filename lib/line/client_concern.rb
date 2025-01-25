module Line
    module ClientConcern
        def client
            @client ||= Line::Bot::Client.new { |config|
                config.channel_secret = ENV["LINE_BOT_CHANNEL_SECRET"]
                config.channel_token = ENV["LINE_BOT_CHANNEL_TOKEN"]
            }
        end
    end
end
