desc "Fetch product prices"
task :fetch_titles => :environment do
	require 'nokogiri'
	require 'open-uri'

	Scrapper.all.each do |product|
		url = product.url
		data = Nokogiri::HTML(open(url))
    doc = data.css(".s-item-container")
    title = doc.css(".s-access-title").text
    product.update_attributes(productName: title)
	end

end