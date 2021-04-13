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
        #binding.pry
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
            year_average = House::get_average_year
            year_compare = House::compare_year(@house)

            stats = {
                "price_sqm" => price_sqm,
                "price_sqm_city" => price_sqm_city,
                "price_sqm_compare" => price_sqm_compare,
                "year_average" => year_average,
                "year_compare" => year_compare
            }            

            ## Convert price_sqm_compare, year_compare to percent
            ## add year_better, price_sqm_better booleans to the stats hash
            ## depending on more than 100 or less than 100
            # data = 
            # HouseSerializer.new(
            #     house: @house,
            #     price_sqm_city: price_sqm_city,
            #     price_sqm_compare: price_sqm_compare,
            #     year_compare: year_compare,
            # ).to_h            

            # binding.pry

            render_json({house: @house.data, stats: stats})
        else
            # House not found
        end

    end

    def not_found
        render({}, 404)
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