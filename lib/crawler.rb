require 'watir'

require_relative 'account'
require_relative 'accounts'
require_relative 'transaction'
require_relative 'transactions'
require_relative 'login_page'
require_relative 'dashboard_page'
require_relative 'account_page'
require_relative 'statement_page'


class Crawler
  URL = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

  def initialize(browser: :firefox)
    @accounts = Accounts.new
    @browser = Watir::Browser.new browser
  end

  def run
    LoginPage.new(@browser, URL).login
    dashboard = DashboardPage.new(@browser)

    dashboard.fetch_accounts { |name|
      AccountPage.new(@browser).fetch_account_into(name, @accounts)
    }

    dashboard.fetch_transactions {
      StatementPage.new(@browser).fetch_transactions(@accounts, from_date: '12/04/2019', to_date: '12/06/2019')
    }

    puts @accounts
    
    close
  end

  def close
    @browser.close
  end
end
