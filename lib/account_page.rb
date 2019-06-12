class AccountPage
  def initialize(browser)
    @browser = browser
    self
  end

  def fetch_account_into(name, container)
    account_info = @browser.div(css: '.acc-info')
    account_info.wait_until(&:present?)
    info = account_info.dl.to_hash
    balance = @browser.div(css: '.acc-bal-directive').h3s[0].text
    container << Account.new(name, balance, info['Валута:'], info['Вид:'])
  end
end
