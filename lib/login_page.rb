# frozen_string_literal: true

require 'watir'

# Page object class for `login` page.
#
class LoginPage
  def initialize(browser, url)
    @browser = browser
    @url = url
  end

  def login
    @browser.goto @url
    @browser.link(css: '#demo-link').wait_until(&:present?).click
  end
end
