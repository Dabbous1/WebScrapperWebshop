require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

def whey_scrapper
    company = 'Body+%26+fit'
    url = "https://www.bodyenfitshop.nl/eiwittenwhey/whey-proteine/?limit=81&manufacturer=#{company}"
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
        price << product_price.css('span.price').text
    end
    headers = ["name", "price"]
    items = name.zip(price)
    CSV.open('data/wheyprotein.csv', 'w+') do |csv|
        csv << headers
        items.each {|row| csv << row }
    end
    byebug
end
whey_scrapper


# # Product Categories                    # Products
# eiwittenwhey                             whey-proteine  eiwitshakes plantaardige-eiwitten eiwitrepen eiwitchips
# afslanken                                afslank-toppers eiwitdieet afslank-supplementen maaltijdvervangers-dieet smart-lifestyle
# vitamines                                vitamine-b vitamin-c vitamine-d vitamines-bodybuilding mineralen 
# aminozuren
# bodybuilding                             bodybuilding-supplementen spieropbouw zma-spieropbouw t-boosters-voor-mannen libido-seksuele-stimulans
# workouts                                 pre-workout-toppers post-workout tijdens-de-training weight-gainers 
# vegan                                    eiwitten repen vitamines
# creatine
# duursport                                energie-repen energie-gels isotone-sportdrank herstel tijdens-de-training
# workouts