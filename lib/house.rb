class House
    ENERGETICS = {
        "A" => 0, "B" => 1, "C" => 2,
        "D" => 3, "E" => 4, "F" => 5,
        "G" => 6
    }

    def self.db
        @db ||= SQLite3::Database.new "./boardimo.db"
        @db.results_as_hash = true
        @db
    end

    def self.all
        db.execute("SELECT * FROM House").map {|row| self.new(row)}
    end

    def self.all_to_h
        db.execute("SELECT * FROM House")
    end

    def self.get_by_link(link)
        data = db.execute("SELECT * FROM House WHERE link LIKE '%#{link}' LIMIT 1")
        self.new(data[0])
    end

    def self.get_links
        db.execute("SELECT link FROM House").map {|row| row["link"]}
    end

    def self.add_houses(data)
        db.execute(
            "INSERT OR IGNORE INTO House VALUES(:link,:img,:name,:description,:city,:surface,:price,:energetics,:year,:fee)",
            data
        )
    end

    # Stats

    def self.get_price_square_meter_city(city_name)
        data = db.execute(" SELECT SUM(price) price_t, SUM(surface) surface_t FROM City
                            JOIN House ON House.CityName = '#{city_name}'")
        (data[0]["price_t"] / data[0]["surface_t"]).to_i
    end

    def self.get_price_square_meter_house(link)
        price_house = 0
        surface = 0
        if link.is_a?(House)
            price_house = link.data["price"]
            surface_house = link.data["surface"]
        else
            data = db.execute("SELECT price, surface FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            price_house = data[0]["price"]
            surface_house = data[0]["surface"]            
        end
        (price_house / surface_house).to_i
    end

    def self.get_average_year
        data = db.execute("SELECT AVG(year) avg FROM House WHERE year > 1000")
        data[0]["avg"].to_i
    end

    def self.get_average_year_city(city_name)
        data = db.execute(" SELECT AVG(year) avg FROM City
                            JOIN House ON House.CityName = City.name
                            WHERE year > 1000")
        data[0]["avg"].to_i
    end

    def self.get_average_energetics_city(city_name)
        data = db.execute(" SELECT AVG(energetics) avg FROM City
                            JOIN House ON House.CityName = '#{city_name}'")
        data[0]["avg"].to_i
    end

    def self.get_renovation_cost_house(link)

        

    end

    # V Percent comparing methods V
    # Return more than 100 if worse or less than 100 if better, excess being the percent 
    # 125 - 100 = 25% more than city average
    # -(90-100) = 10% better than city average

    def self.compare_price_square_meter(link)
        price_square_meter = 0
        city_name = ""
        if link.is_a?(House)
            price_square_meter = (link.data["price"] / link.data["surface"]).to_i
            city_name = link.data["cityName"]
        else
            data = db.execute("SELECT price, surface, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            price_square_meter = (data[0]["price"] / data[0]["surface"]).to_i
            city_name = data[0]["cityName"]
        end
        price_square_meter_city = get_price_square_meter_city(city_name)
        price_square_meter * 100 / price_square_meter_city
    end

    def self.compare_year(link)
        year = 0
        city_name = ""
        if link.is_a?(House)
            year = link.data["year"]
        else
            data = db.execute("SELECT year, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            year = data[0]["year"]
        end
        year_city = get_average_year_city(city_name)
        year * 100 / year_city
    end

    def self.compare_energetics(link)
        energetics = 0
        city_name = ""
        if link.is_a?(House)
            energetics = link.data["energetics"]
            city_name = link.data["cityName"]
        else
            data = db.execute("SELECT energetics, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            energetics = data[0]["energetics"]
            city_name = data[0]["cityName"]
        end
        energetics_city = get_average_energetics_city(city_name)
        energetics * 100 / energetics_city
    end

    attr_reader :data
    def initialize(data)
        @data = data
    end
end