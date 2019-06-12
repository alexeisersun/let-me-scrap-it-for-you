require 'watir'

require_relative 'account'
require_relative 'accounts'
require_relative 'transaction'
require_relative 'transactions'

class Crawler
  URL = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

  def initialize(browser: nil)
    @browser = browser
    @accounts = Accounts.new
  end

  def run
    open
    pass_login
    print_accounts
    print_transactions('12/04/2019', '12/06/2019')
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
    accounts_table = @browser.table(id: "dashboardAccounts")
    accounts_table.wait_until(&:present?)
    accounts_table = accounts_table.tbody
    accounts_table.rows.each do |r|
      r.wait_until(&:present?).link.click
      account_info = @browser.div(css: '.acc-info')
      account_info.wait_until(&:present?)
      fields = [:branch, :currency, :owner, :role, :category]
      info = account_info.dl.to_hash

      balance = @browser.div(css: '.acc-bal-directive').h3s[0].text

      @browser.back
      @browser.table(id: "dashboardAccounts").wait_until(&:present?)

      @accounts << Account.new(r.link.text, balance, info['Валута:'], info['Вид:'])
    end
    puts
    puts @accounts
  end

  def print_transactions(start_date, end_date)
    link = @browser.link(css: 'div#dashStep4 #step3').wait_until(&:present?)
    link.wait_until(&:present?)
    sleep(1)
    link.click


    date_from = @browser.div(css: '.acc-statement .controls div', name: 'FromDate')
    date_from.wait_until(&:present?)
    date_from.text_field.set start_date

    date_to = @browser.div(css: '.acc-statement .controls div', name: 'ToDate')
    date_to.wait_until(&:present?)
    date_to.text_field.set end_date

    account_picker = @browser.div(css: '.acc-statement .controls div', name: 'Iban')
    account_picker.wait_until(&:present?)

    btn = account_picker.button
    btn.wait_until(&:present?)
    sleep(1)
    btn.click

    option = account_picker.ul
    option.wait_until(&:present?)
    option.list_items.each{  |i|
      account_name, _ = i.link.text.split
      transactions = @accounts[account_name].transactions

      i.link.click
      show_btn = @browser.button(id: 'button')
      show_btn.wait_until(&:present?)
      show_btn.click

      begin
        account_statements = @browser.table(id: 'accountStatements')
        account_statements.wait_until(timeout: 3, &:present?)
        account_statements.tbody.rows.each { |row|
          date = Date.parse(row[0].text)
          description = row[4].text
          amount = row[2].text.to_i + row[3].text.to_i
          transactions << Transaction.new(date, description, amount)
        }
      rescue Exception
        puts "table does not exist"
      end
      sleep(3)
      btn.click
    }
    puts @accounts.to_hash
  end
end
