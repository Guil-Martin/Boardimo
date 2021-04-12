require "nokogiri"
require "open-uri"
require "sqlite3"
require "pry"
require "./lib/house"
require "./lib/house_sanitizer"

cities = {
    vannes: "https://simply-home.herokuapp.com",
    questembert: "https://simply-home-group.herokuapp.com",
    auray: "https://simply-home-cda.herokuapp.com"
}

## VANNES

houses_page = URI.open("#{cities[:vannes]}/house.php")
noko = Nokogiri::HTML(houses_page)

house_links = noko.css(".articleHouse a").map { |link| link["href"]}

house_links.each do |link|
    house_single = URI.open("#{cities[:vannes]}/#{link}")
    noko = Nokogiri::HTML(house_single)
    
    link = "#{cities[:vannes]}/#{link}"
    name = noko.css("#titleSingleArticle h2").children.text
    description = noko.css("#articleContent").children.text
    city = noko.css(".location").children.text
    surface = noko.css(".size").children.text
    price = noko.css(".price").children.text
    energetics = noko.css(".energy").children.text
    year = noko.css(".foundation-years").children.text 
    fee = noko.css("#articleSubContent").children.text 
    
    data =
        HouseSanitizer.new(
            name: name,
            link: link,
            description: description,
            city: city,
            surface: surface,
            price: price,
            energetics: energetics,
            year: year,
            fee: fee
        ).to_h

    House::add_houses(data)

end

## AURAY

houses_page = URI.open("#{cities[:auray]}/pages/nosmaisons.php")
noko = Nokogiri::HTML(houses_page)

house_links = noko.css("#house-cards .card a").map { |link| link["href"]}

house_links.each do |link|
    house_single = URI.open("#{cities[:auray]}/pages/#{link}")
    noko = Nokogiri::HTML(house_single)
    
    link = "#{cities[:auray]}/#{link}"
    name = noko.css("h1").children.text

    stats = noko.css("#single-ad-description > div > p")

    surface = stats[0].text
    city = stats[1].text
    price = stats[2].text
    energetics = stats[3].text
    year = stats[4].text

    desc = noko.css("#single-ad-description > p")
    description = desc.children[0].text
    fee = desc.children[1].text
    
    data =
        HouseSanitizer.new(
            name: name,
            link: link,
            description: description,
            city: city,
            surface: surface,
            price: price,
            energetics: energetics,
            year: year,
            fee: fee
        ).to_h

    House::add_houses(data)

end

## QUESTEMBERT

houses_page = URI.open("#{cities[:questembert]}/NosMaisons.php")
noko = Nokogiri::HTML(houses_page)

house_links = noko.css("a.card").map { |link| link["href"]}

house_links.each do |link|
    house_single = URI.open("#{cities[:questembert]}/#{link}")
    noko = Nokogiri::HTML(house_single)
    
    link = "#{cities[:questembert]}/#{link}"
    name = noko.css(".title").children.text
    description = noko.css(".houseDescription").children.text
    city = noko.css(".city").children.text
    surface = noko.css(".surface").children.text
    price = noko.css(".price").children.text
    energetics = noko.css(".energetic").children.text
    year = noko.css(".year").children.text
    fee = noko.css(".fees").children.text
 
    noko.css(".houseInfoBlock").children.text 
    
    data =
        HouseSanitizer.new(
            name: name,
            link: link,
            description: description,
            city: city,
            surface: surface,
            price: price,
            energetics: energetics,
            year: year,
            fee: fee
        ).to_h

    #  binding.pry

    # p data[:link]
    # p data[:name]
    # p data[:description]
    # p data[:city]
    # p data[:surface]
    # p data[:price]
    # p data[:energetics]
    # p data[:year]
    # p data[:fee]

    House::add_houses(data)

end

# p "#{cities[:questembert]}/NosMaisons.php"