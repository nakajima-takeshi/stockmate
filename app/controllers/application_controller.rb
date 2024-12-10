class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def client
      @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_BOT_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_BOT_CHANNEL_TOKEN"]
      }
  end
end
