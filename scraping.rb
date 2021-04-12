require "nokogiri"
require "open-uri"
require "sqlite3"
require "pry"
require "./lib/house"
require "./lib/house_sanitizer"

cities = {
    vannes: "https://simply-home.herokuapp.com",
    questembert: "https://simply-home-group.herokuapp.com",
    auray: "https://simply-home-cda.herokuapp.com/pages"
}

html = URI.open("#{cities[:vannes]}/house.php")
noko = Nokogiri::HTML(html)

house_links = noko.css(".articleHouse a").map { |link| link["href"]}

house_links.each do |link|
    html = URI.open("#{cities[:vannes]}/#{link}")
    noko = Nokogiri::HTML(html)
    
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

    p data[:link]     
    p data[:name]
    p data[:description]
    p data[:city]
    p data[:surface]
    p data[:price]
    p data[:energetics]
    p data[:year]
    p data[:fee]

    House::add_houses(data)

end





# p "#{cities[:questembert]}/NosMaisons.php"
# p "#{cities[:auray]}/nosmaisons.php"