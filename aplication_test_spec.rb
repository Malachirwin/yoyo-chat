require "rack/test"
require "rspec"
require "capybara"
require "capybara/rspec"
require "selenium/webdriver"
require "pry"

ENV["RACK_ENV"] = 'test'

Capybara.configure do |config|
  config.run_server = false
  config.app_host = "http://localhost:3000"
  config.default_driver = :selenium_chrome_headless
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.describe "App", type: :feature do
  describe "App", :js do
    it "visit home page" do
      visit "/"
      expect(page).to have_content "home"
    end

    it "visit about page" do
      visit "/static_pages/about"
      expect(page).to have_content "About"
    end

    it "visit contact page" do
      visit "/static_pages/contact"
      expect(page).to have_content "Contact"
    end

    it "visit help page" do
      visit "/static_pages/help"
      expect(page).to have_content "Help"
    end
  end
end
