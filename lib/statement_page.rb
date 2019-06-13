require 'nokogiri'
require_relative 'safe_scrapper'

class StatementPage
  include SafeScrapper

  def initialize(browser)
    @browser = browser
  end

  def fetch_transactions_into(container, from_date: Date.today.strftime('%d/%m/%Y') , to_date: Date.today.strftime('%d/%m/%Y'))
    date_field('FromDate', from_date)
    date_field('ToDate', to_date)

    safe_click_on account_selector_button
    accounts.each { |i|
      account_name, _ = i.link.text.split
      transactions = container[account_name].transactions


      safe_click_on i.link
      safe_click_on show_button

      extract_transactions(from: @browser, into: transactions)
      safe_click_on account_selector_button
    }
  end

  private

  def control(name)
    @browser.div(css: '.acc-statement .controls div', name: name)
  end

  def date_field(name, new_date)
    control(name).text_field.set new_date
  end

  def show_button
    @browser.button(id: 'button')
  end

  def account_selector_button
    control('Iban').button
  end

  def accounts
    control('Iban').ul.wait_until(&:present?).list_items
  end

  def extract_transactions!(from: nil, into: nil)
    return if !from || !into
    html = Nokogiri::HTML(from.html)
    rows = html.css('#accountStatements tbody tr')
    rows.each { |row|
      cells = row.css('td')
      date = DateTime.parse(cells[0].content).iso8601
      description = cells[4].content
      amount = cells[2].content.to_i + cells[3].content.to_i
      into << Transaction.new(date, description, amount)
    }
  end

  def extract_transactions(from: nil, into: nil, timeout: 3)
    begin
      @browser.table(id: 'accountStatements').wait_until(timeout: timeout, &:present?)
      extract_transactions!(from: from, into: into)
    rescue Watir::Wait::TimeoutError => e
      puts "Element does not exist."
    end
  end
end
