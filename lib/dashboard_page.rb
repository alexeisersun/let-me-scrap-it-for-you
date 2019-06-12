require_relative 'account'

class DashboardPage
  def initialize(browser, url, accounts)
    @browser = browser
    @url = url
    @accounts = accounts
    self
  end

  def fetch_accounts
    accounts_table = @browser.table(id: "dashboardAccounts")
    accounts_table.wait_until(&:present?)
    accounts_table = accounts_table.tbody
    accounts_table.rows.each do |r|
      r.wait_until(&:present?).link.click
      account_info = @browser.div(css: '.acc-info')
      account_info.wait_until(&:present?)
      info = account_info.dl.to_hash

      balance = @browser.div(css: '.acc-bal-directive').h3s[0].text

      @browser.back
      @browser.table(id: "dashboardAccounts").wait_until(&:present?)

      @accounts << Account.new(r.link.text, balance, info['Валута:'], info['Вид:'])
    end
  end

end
