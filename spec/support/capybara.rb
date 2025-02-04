require 'capybara/rspec'
require 'selenium-webdriver'
require 'webdrivers'

Capybara.register_driver :remote_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--no-sandbox')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1680,1050')
    options.add_argument('--disable')
    Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], capabilities: options)
end
