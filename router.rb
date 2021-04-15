require "./lib/controller"

class Router
    def call(env)        
        path = env["REQUEST_PATH"]
        req = Rack::Request.new(env)

        controller = Controller.instance
        return controller.req_options if req.options?

        body = req.body.gets
        params = {}

        params.merge!(body ? JSON.parse(body) : {})
        
        controller.params = params

        case path
        when "/"
            controller.index
        when "/index"
            controller.index
        when "/api_index"
            controller.api_index
        when "/api_scan"
            controller.api_scan(params["link"])
        when "/api_links"
            controller.api_links
        else
            controller.not_found
        end
    end
end