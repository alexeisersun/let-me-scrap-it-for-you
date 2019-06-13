# frozen_string_literal: true

require 'watir'

require_relative 'account'
require_relative 'accounts'
require_relative 'transaction'
require_relative 'transactions'
require_relative 'login_page'
require_relative 'dashboard_page'
require_relative 'account_page'
require_relative 'statement_page'

# Operate over a bank account.
#
class Crawler
  URL = 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'

  def initialize(browser: :firefox)
    @accounts = Accounts.new
    @browser = Watir::Browser.new browser
  end

  # Navigate to bank account, fetch accounts and transactions.
  #
  def run
    login
    dashboard = DashboardPage.new(@browser)
    fetch_accounts(dashboard)
    fetch_transactions(dashboard)

    puts @accounts

    close
  end

  def login
    LoginPage.new(@browser, URL).login
  end

  def fetch_accounts(dashboard)
    dashboard.fetch_accounts do |name|
      AccountPage.new(@browser).fetch_account_into(name, @accounts)
    end
  end

  def fetch_transactions(dashboard)
    dashboard.fetch_transactions do
      two_months_ago = (Date.today - 60).strftime('%d/%m/%Y')
      today = Date.today.strftime('%d/%m/%Y')
      StatementPage.new(@browser)
                   .fetch_transactions_into(@accounts,
                                            from_date: two_months_ago,
                                            to_date: today)
    end
  end

  def close
    @browser.close
  end
end
