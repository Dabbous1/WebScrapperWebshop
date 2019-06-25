require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'csv'
require 'byebug'

class Wheyscrapper
  def whey_scrapper
    company = 'Body+%26+fit'
    url = "https://www.bodyenfitshop.nl/afslanken/afslank-toppers/?manufacturer=#{company}"
    unparsed_page = open(url).read
    @parsed_page = Nokogiri::HTML(unparsed_page)
    product_scrapper
    prices_scrapper
    # csv = CSV.open('wheyprotein.csv', 'wb')
  end


  def product_scrapper
    @products = Array.new
    product_names = @parsed_page.css('div.product-primary')
    product_names.each do |product_name|
      product = {
        name: product_name.css('h2.product-name').text
      }
      @products << product
    end
  end

  def prices_scrapper
    @prices = Array.new
    @product_prices = @parsed_page.css('div.price-box')
    @product_prices.each do |product_price|
      price = {
        amount: product_price.css('span.price').text
      }
      @prices << price
    end
  end
  byebug
end

w = Wheyscrapper.new.whey_scrapper