require "nokogiri"
require "open-uri"
require "pry"

require "tilt"
require "erb"
require "json"
require "sqlite3"

require "./lib/house"
require "./lib/house_sanitizer"

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