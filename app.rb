# frozen_string_literal: true

at_exit { puts 'I scraped it for you. <3' }
puts 'Let me scrap it for you.'

require_relative 'lib/scraper'

scraper = Scraper.new
scraper.run
