require 'watir'

class Crawler
  URL = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

  def initialize(browser: nil)
    @browser = browser
  end

  def run
    open
    pass_login
    print_accounts
    close
  end

  private

  def open
    @browser = Watir::Browser.new @browser
    @browser.goto URL
  end

  def pass_login
    demo_link = @browser.link(css: "#demo-link").wait_until(&:present?)
    demo_link.click
  end

  def close
    @browser.close
  end

  def print_accounts
    account_details = []
    accounts_table = @browser.table(id: "dashboardAccounts").wait_until(&:present?).tbody
    accounts_table.rows.each do |r|
      r.wait_until(&:present?).link.click
      account_info = @browser.div(css: '.acc-info').wait_until(&:present?)
      fields = [:branch, :currency, :owner, :role, :category]
      info = account_info.dl.to_hash

      balance = @browser.div(css: '.acc-bal-directive').h3s[0].text

      @browser.back
      @browser.table(id: "dashboardAccounts").wait_until(&:present?)

      account_details <<
      {
        name: info['Титуляр:'], currency: info['Валута:'], balance: balance,
        nature: info['Вид:']
      }
    end
    puts account_details
  end
end
