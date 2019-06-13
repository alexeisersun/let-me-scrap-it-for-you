# frozen_string_literal: true

require_relative 'account'
require_relative 'safe_scrapper'

# Page object class for `dashboad` page.
#
class DashboardPage
  include SafeScrapper

  def initialize(browser)
    @browser = browser
  end

  def fetch_accounts(&block)
    accounts_dashboard.tbody.rows.each do |r|
      link = r.link.text
      r.wait_until(&:present?).link.click
      block.call link
      back
      accounts_dashboard
    end
  end

  def fetch_transactions(&block)
    safe_click_on transactions_dashboard
    block.call
    back
  end

  private

  def accounts_dashboard
    wait @browser.table(id: 'dashboardAccounts')
  end

  def transactions_dashboard
    @browser.link(css: 'div#dashStep4 #step3')
  end

  def back
    @browser.back
  end
end
