class LineBotController < ApplicationController
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
                    client.reply_message(event["replyToken"], message)
                end
            end
        end
    end
end
