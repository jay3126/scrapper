desc "Fix products"
task :fix_products => :environment do
	require 'nokogiri'
	require 'open-uri'

	# destroying all Products data as there is no need for the same.
	puts "********** Deleting products **************"
	Product.all.destroy_all

	# re-creating the products with correct relationship with Scrapper.
	puts "*************** re-creating products for each scrapper with correct db relationship ********************"
	Scrapper.all.each do |scrap|
		url = scrap.url
		doc = Nokogiri::HTML(open(url))
		items = doc.css(".s-item-container")
		puts "Fetching & creating products from #{scrap.id} : #{url}"
		items.each do |item|
			title = item.css(".s-access-title").text.strip
			price = item.css(".s-price").text.split(',').map!(&:strip).join().gsub(/\p{Space}/,'').to_d
			rating = item.css("span+ .a-text-normal").text.to_f
			cod = item.css(".a-spacing-top-mini").text
			user_id = User.first.id
			Product.create!(title: title, price: price, rating: rating, cod: cod, scrapper_id: scrap.id, user_id: user_id)
		end
		puts "Finished fetching & creating products from #{scrap.id} : #{url}"
		puts "****************************************************************"
	end
	puts "************* Task finished *****************"
end