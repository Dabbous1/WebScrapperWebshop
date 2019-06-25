require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

def web_scrapper
    product_category = 'workouts'
    product = ''
    company = ''
    url = "https://www.bodyenfitshop.nl/eiwittenwhey/whey-proteine/?limit=81"
    unparsed_page = open(url).read
    parsed_page = Nokogiri::HTML(unparsed_page)
    product_names = parsed_page.css('div.product-primary')
    name = Array.new
    product_names.each do |product_name| 
        name << product_name.css('h2.product-name a').children[0].text.gsub(/\s{2,}/, '')
    end
    product_prices = parsed_page.css('div.price-box')
    price = Array.new
    product_prices.each do |product_price|
        price << product_price.css('span.price').text.gsub(/€/, '')
    end
    headers = ["name", "price"]
    items = name.zip(price)
    CSV.open('data/allproducts.csv', 'w+') do |csv|
        csv << headers
        items.each {|row| csv << row }
    end
    byebug
end
web_scrapper


