# Let me crawl it for you, in the bank

## Prerequires

Run `bundle install` in the project's directory to install required gems.

## Usage

Run `ruby app.rb` in your console to launch the application.
By default it will open your Firefox browser and navigate to a demo account on [FiBank](https://my.fibank.bg/oauth2-server/login?client_id=E_BANK).
To run in a different browser, pass `:chrome`, `:safari` or `:opera` symbols to `browser:` keyword parameter of `Crawler.new`:

```ruby
# use default Firefor browser
crawler = Crawler.new
crawler.run

# use Chrome browser
crawler = Crawler.new(browser: :chrome)
crawler.run
```

## License
Apache License, version 2. See [LICENSE.txt](LICENSE.txt) for details.
