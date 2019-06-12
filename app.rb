at_exit { puts "I crawled it for you. <3" }
puts "Let me crawl it for you."

require_relative 'lib/crawler'

crawler = Crawler.new
crawler.run
