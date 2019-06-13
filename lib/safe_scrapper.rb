# frozen_string_literal: true

require 'watir'

# Provide methods for safe navigation in Watir.
#
module SafeScrapper
  # @deprecated Use {#safe_click_on} if want to wait and click.
  # Since Watir doesn't guarantee an `Watir::Element` is not obscured when
  # present, this method catches the corresponding error.
  def wait(element)
    element.wait_until(&:present?)
  rescue Selenium::WebDriver::Error::ElementClickInterceptedError
    sleep(1)
    retry
  end

  # Wait while `Watir::Element` is present and then click. Since Watir doesn't
  # guarantee the element will be unobscured, the click is wrapped by a
  # rescue-retry block.
  def safe_click_on(element)
    element.wait_until(&:present?).click
  rescue Selenium::WebDriver::Error::ElementClickInterceptedError
    sleep(1)
    retry
  end
end
