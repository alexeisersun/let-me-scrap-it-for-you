require 'watir'

module SafeScrapper
  def wait(element)
    begin
      element.wait_until(&:present?)
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError => e
      sleep(1)
      retry
    end
  end

  def safe_click_on(element)
  	begin
      element.wait_until(&:present?).click
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError => e
      sleep(1)
      retry
    end
  end
end
