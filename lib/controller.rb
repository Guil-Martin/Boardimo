require "nokogiri"
require "open-uri"
require "pry"

require "tilt"
require "erb"
require "json"
require "sqlite3"

require "./lib/house"
require "./lib/house_sanitizer"
require "./lib/house_serializer"
require "./lib/stats_serializer"

class Controller

    attr_accessor :params
    def self.instance
        @instance ||= Controller.new
    end

    def index 
        @houses = House::all
        render({houses: @houses})
    end

    def api_index 
        @houses = House::all_to_h
        render_json({houses: @houses})
    end

    def api_scan(link)
        @house = House::get_by_link(link)
        p @house.data["name"]
        p link
        if !@house.nil?

            price_sqm = House::get_price_square_meter_house(@house)
            price_sqm_city = House::get_price_square_meter_city(@house.data["cityName"])
            price_sqm_compare = House::compare_price_square_meter(@house)
            year_average = House::get_average_year_city(@house.data["cityName"])
            year_compare = House::compare_year(@house)
            energetics_average = House::get_average_energetics_city(@house.data["cityName"])
            energetics_compare = House::compare_energetics(@house)
            # renovation_cost = House::get_renovation_cost_House(@house)
            # p @house.data

            stats = {
                "price_sqm" => price_sqm,
                "price_sqm_city" => price_sqm_city,
                "price_sqm_compare" => price_sqm_compare,
                "year_average" => year_average,
                "year_compare" => year_compare,
                "energetics_average" => energetics_average,
                "energetics_compare" => energetics_compare
            }

            ## Convert prices, add m² to surface
            house_data = HouseSerializer.new(house: @house.data).to_h

            p house_data
            # binding.pry

            ## Convert price_sqm_compare, year_compare to percent
            ## add year_better, price_sqm_better booleans to the stats hash
            ## depending on more than 100 or less than 100
            stats_data = StatsSerializer.new(stats: stats).to_h

            links = House::get_links

            # binding.pry

            render_json({house: house_data, stats: stats_data})
        else
            # House not found
        end

    end

    def api_links 
        links = House::get_links
        render_json({links: links})
    end    

    def not_found
        render({}, 404)
    end

    def req_options
        [
            200, 
            {"Content-Type" => "application/json"}, 
            [{}]
        ]
    end

    private

    def render(params, code = 200)
        view = caller_locations(1,1)[0].label
        template = Tilt.new("./lib/views/#{view}.html.erb")
        [
            code,
            {"Content-type" => "text/html"},
            template.render(self, params)
        ]
    end

    def render_json(params, code = 200)
        [
          code,
          { "Content-Type" => "application/json" },
          [params.to_json]
        ]
    end

    def redirect(to)
        [302, { "Location" => to }, []]
    end

end