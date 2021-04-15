require "nokogiri"
require "open-uri"
require "./lib/house"
require "./lib/house_sanitizer"

class Scraper
    
    CITIES = {
        vannes: "https://simply-home.herokuapp.com",
        auray: "https://simply-home-cda.herokuapp.com",
        questembert: "https://simply-home-group.herokuapp.com"
    }

    def self.all
        scrap_vannes
        scrap_auray
        scrap_questembert
    end

    def self.scrap_vannes
        p  "#{CITIES[:vannes]}/house.php"
        houses_page = URI::open("#{CITIES[:vannes]}/house.php")
        @noko = Nokogiri::HTML(houses_page)        
        house_links = @noko.css(".articleHouse a").map { |link| link["href"] }
        house_links.each do |link|
            house_single = URI.open("#{CITIES[:vannes]}/#{link}")
            @noko = Nokogiri::HTML(house_single)
            scraped = scrap_single_vannes("#{CITIES[:vannes]}", "#{CITIES[:vannes]}/#{link}")
            add_db(scraped: scraped)
        end
    end

    def self.scrap_auray        
        houses_page = URI::open("#{CITIES[:auray]}/pages/nosmaisons.php")
        @noko = Nokogiri::HTML(houses_page)
        house_links = @noko.css("#house-cards .card a").map { |link| link["href"] }
        house_links.each do |link|
            house_single = URI::open("#{CITIES[:auray]}/pages/#{link}")
            @noko = Nokogiri::HTML(house_single)
            scraped = scrap_single_auray("#{CITIES[:auray]}", "#{CITIES[:auray]}/#{link}")
            add_db(scraped: scraped)
        end
    end

    def self.scrap_questembert
        houses_page = URI.open("#{CITIES[:questembert]}/NosMaisons.php")
        @noko = Nokogiri::HTML(houses_page)        
        house_links = @noko.css(".articleHouse a").map { |link| link["href"]}
        house_links.each do |link|
            house_single = URI::open("#{CITIES[:questembert]}/#{link}")
            @noko = Nokogiri::HTML(house_single)
            scraped = scrap_single_questembert("#{CITIES[:questembert]}", "#{CITIES[:questembert]}/#{link}")
            add_db(scraped: scraped)
        end
    end

    def self.scrap_single(link)

        cityLink = CITIES.find { |k,v| break v if link.include? v }

        unless cityLink.empty?
            
            house_single = URI::open(link)
            @noko = Nokogiri::HTML(house_single)
    
            scraped = {}
            case cityLink
            when CITIES[:vannes]        
                scraped = scrap_single_vannes(CITIES[:vannes], link)
            when CITIES[:auray]
                scraped = scrap_single_auray(CITIES[:auray], link)
            when CITIES[:questembert]
                scraped = scrap_single_questembert(CITIES[:questembert], link)
            end

            add_db(scraped: scraped)

        end

    end

    private

    def self.add_db(scraped:)
        data = HouseSanitizer.new(
            link: scraped["link"],
            img: scraped["img"],
            name: scraped["name"],
            description: scraped["description"],
            city: scraped["city"],
            surface: scraped["surface"],
            price: scraped["price"],
            energetics: scraped["energetics"],
            year: scraped["year"],
            fee: scraped["fee"]
        ).to_h
        House::add_houses(data)
    end

    def self.scrap_single_vannes(cityLink, link)
        scraped = {}
        scraped["link"] = link
        scraped["img"] = "#{cityLink}#{@noko.css("#singleArticleImage > img")[0].attr("src")[1..-1]}"  
        scraped["name"] = @noko.css("#titleSingleArticle h2").children.text
        scraped["description"] = @noko.css("#articleContent").children.text
        scraped["city"] = @noko.css(".location").children.text
        scraped["surface"] = @noko.css(".size").children.text
        scraped["price"] = @noko.css(".price").children.text
        scraped["energetics"] = @noko.css(".energy").children.text
        scraped["year"] = @noko.css(".foundation-years").children.text 
        scraped["fee"] = @noko.css("#articleSubContent").children.text
    end

    def self.scrap_single_auray(cityLink, link)
        scraped = {}
        scraped["link"] = link
        scraped["img"] = "#{cityLink}#{@noko.css("#secion-ad > img")[0].attr("src")[2..-1]}"
        scraped["name"] = @noko.css("h1").children.text
        stats = @noko.css("#single-ad-description > div > p")
        scraped["surface"] = stats[0].text
        scraped["city"] = stats[1].text
        scraped["price"] = stats[2].text
        scraped["energetics"] = stats[3].text
        scraped["year"] = stats[4].text    
        desc = @noko.css("#single-ad-description > p")
        scraped["description"] = desc.children[0].text
        scraped["fee"] = desc.children[1].text
        scraped
    end

    def self.scrap_single_questembert(cityLink, link)
        scraped = {}
        scraped["link"] = link
        scraped["img"] = "#{cityLink}/#{@noko.css(".houseImg > img")[0].attr("src")}"
        scraped["name"] = @noko.css(".title").children.text
        scraped["description"] = @noko.css(".houseDescription").children.text
        scraped["city"] = @noko.css(".city").children.text
        scraped["surface"] = @noko.css(".surface").children.text
        scraped["price"] = @noko.css(".price").children.text
        scraped["energetics"] = @noko.css(".energetic").children.text
        scraped["year"] = @noko.css(".year").children.text
        scraped["fee"] = @noko.css(".fees").children.text     
        # @noko.css(".houseInfoBlock").children.text 
        scraped
    end

end