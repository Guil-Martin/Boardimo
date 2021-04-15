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

    def self.get_total_houses_city(city_name)
        req = db.execute("SELECT COUNT(*) total FROM House WHERE cityName='#{city_name}'")
        req[0]["total"]
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
                            JOIN House ON House.CityName = '#{city_name}'
                            WHERE year > 1000")
        data[0]["avg"].to_i
    end

    def self.get_average_energetics_city(city_name)
        data = db.execute(" SELECT AVG(energetics) avg FROM City
                            JOIN House ON House.CityName = '#{city_name}'")
        data[0]["avg"].to_i
    end

    def self.get_renovation_cost_house(link)
        current_year = Time.new.year
        data = {}
        if link.is_a?(House)
            data = link.data            
        else
            req = db.execute("SELECT year, surface FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            data = req[0]
        end
        result = {}
        result["oldness"] = current_year - data["year"]
        cost = oldness_cost(result["oldness"])
        result["extra_cost"] = cost
        result["renov"] = (345 + cost) * data["surface"]
        result["avg_less"] = (345 * data["surface"]) - result["renov"]
        result
    end
    def self.oldness_cost(oldness)
        case oldness
        when 0..9 then cost = -245
        when 10..19 then cost = -105
        when 20..39 then cost = 95
        else cost = 355
        end
    end

    # V Percent comparing methods V
    # Return more than 100 if worse or less than 100 if better, excess being the percent 
    # 125 - 100 = 25% more than city average
    # -(90-100) = 10% better than city average

    def self.compare_price_square_meter(link)
        if link.is_a?(House)
            data = link.data
        else
            req = db.execute("SELECT price, surface, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            data = req[0]
        end
        price_square_meter = (data["price"] / data["surface"]).to_i
        price_square_meter_city = get_price_square_meter_city(data["cityName"])
        price_square_meter * 100 / price_square_meter_city
    end

    def self.compare_year(link)
        if link.is_a?(House)
            data = link.data
        else
            req = db.execute("SELECT year, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            data = req[0]
        end

        total_houses = get_total_houses_city(data["cityName"])

        req = db.execute("SELECT COUNT(*) total FROM House WHERE '#{data["year"]}' > year AND cityName='#{data["cityName"]}'")
        more_recent = req[0]["total"]

        more_recent * 100 / total_houses
    end

    def self.compare_energetics(link)
        data = {}
        if link.is_a?(House)
            data = link.data
        else
            req = db.execute("SELECT energetics, cityName FROM House WHERE link LIKE '%#{link}' LIMIT 1")
            data = req[0]
        end

        total_houses = get_total_houses_city(data["cityName"])

        req = db.execute("SELECT COUNT(*) total FROM House WHERE '#{data["energetics"]}' < energetics AND cityName='#{data["cityName"]}'")
        better = req[0]["total"]

        better * 100 / total_houses
    end

    attr_reader :data
    def initialize(data)
        @data = data
    end
end