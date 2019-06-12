require 'nokogiri'

class AccountPage
  def initialize(browser)
    @browser = browser
    self
  end

  def fetch_account_into(name, container)
    @browser.div(css: '.acc-info').wait_until(&:present?)

    html = Nokogiri::HTML(@browser.html)
    account_info = html.css('div.acc-info dl dd')
    balance, currency = html.at_css('.acc-bal-directive h3').content.split
    balance = balance.to_f
    nature = account_info[4].content
    container << Account.new(name, balance, currency, nature)
  end
end
