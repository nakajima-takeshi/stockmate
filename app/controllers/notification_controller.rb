class NotificationController < ApplicationController
    skip_before_action :verify_authenticity_token

    def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
    case event
        when Line::Bot::Event::Message
        case event.type
            when Line::Bot::Event::MessageType::Text
                message = {
                    type: "text",
                    text: event.message["text"]
                }
                client.reply_message(event['replyToken'], message)
            end
        end
    end

    end

    private

    def client
        @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_BOT_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_BOT_CHANNEL_TOKEN"]
        }
    end
end
