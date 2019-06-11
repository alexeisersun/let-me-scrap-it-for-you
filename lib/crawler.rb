require 'watir'

class Crawler
  URL = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

  def initialize(browser: nil)
    @browser = browser
  end

  def run
    open
    pass_login
    close
  end

  private

  def open
    @browser = Watir::Browser.new @browser
    @browser.goto URL
  end

  def pass_login
    demo_link = @browser.link(css: "#demo-link").wait_until(&:present?)
    p demo_link
    demo_link.click
  end

  def close
    @browser.close
  end
end
