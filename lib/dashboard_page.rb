require_relative 'account'

class DashboardPage
  def initialize(browser)
    @browser = browser
    self
  end

  def fetch_accounts(&block)
    accounts_dashboard.tbody.rows.each do |r|
      link = r.link.text
      r.wait_until(&:present?).link.click
      block.call(link)
      back
      accounts_dashboard
    end
  end

  def fetch_transactions(&block)
    transactions_dashboard.click
    block.call
    back
  end

  private
  def accounts_dashboard
    @browser.table(id: "dashboardAccounts").wait_until(&:present?)
  end

  def transactions_dashboard
    @browser.link(css: 'div#dashStep4 #step3').wait_until(&:present?)
  end

  def back
    @browser.back
  end

end
