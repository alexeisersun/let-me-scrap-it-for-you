require 'nokogiri'

class AccountPage
  def initialize(browser)
    @browser = browser
    self
  end

  def fetch_account_into(name, container)
    begin
      account_info_div

      html = Nokogiri::HTML(@browser.html)
      account_info = html.css('div.acc-info dl dd')
      balance, currency = html.at_css('.acc-bal-directive h3').content.split
      balance = balance.to_f
      nature = account_info[4].content
      container << Account.new(name, balance, currency, nature)
    rescue NoMethodError => e
      sleep(1)
      account_info_div
      retry
    end
  end

  def account_info_div
    @browser.div(css: '.acc-info').wait_until(&:present?)
  end
end
