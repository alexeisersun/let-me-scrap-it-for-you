require_relative 'account'

class DashboardPage
  def initialize(browser)
    @browser = browser
    self
  end

  def fetch_accounts(&block)
    accounts_table = @browser.table(id: "dashboardAccounts")
    accounts_table.wait_until(&:present?)
    accounts_table = accounts_table.tbody
    accounts_table.rows.each do |r|
      link = r.link.text
      r.wait_until(&:present?).link.click
      block.call(link)
      @browser.back
      @browser.table(id: "dashboardAccounts").wait_until(&:present?)
    end
  end

end
