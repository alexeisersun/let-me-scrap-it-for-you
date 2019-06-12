require 'watir'

class LoginPage
  def initialize(browser, url)
    @browser = browser
    @url = url
    self
  end

  def login
    @browser.goto @url
    @browser.link(css: "#demo-link").wait_until(&:present?).click
  end
end
