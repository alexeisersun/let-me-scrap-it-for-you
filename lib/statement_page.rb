class StatementPage
  def initialize(browser)
    @browser = browser
  end

  def fetch_transactions_into(container, from_date: Date.today.strftime('%Y/%m/%d') , to_date: Date.today.strftime('%Y/%m/%d'))
    date_from = @browser.div(css: '.acc-statement .controls div', name: 'FromDate')
    date_from.wait_until(&:present?)
    date_from.text_field.set from_date

    date_to = @browser.div(css: '.acc-statement .controls div', name: 'ToDate')
    date_to.wait_until(&:present?)
    date_to.text_field.set to_date

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
      transactions = container[account_name].transactions

      i.link.click
      show_btn = @browser.button(id: 'button')
      show_btn.wait_until(&:present?)
      show_btn.click

      begin
        account_statements = @browser.table(id: 'accountStatements')
        account_statements.wait_until(timeout: 3, &:present?)
        account_statements.tbody.rows.each { |row|
          date = DateTime.parse(row[0].text).iso8601
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
  end

end
