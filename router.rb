require "./lib/controller"

class Router
    def call(env)        
        path = env["REQUEST_PATH"]
        req = Rack::Request.new(env)

        body = req.body.gets
        params = {}

        params.merge!(body ? JSON.parse(body) : {})

        controller = Controller.instance
        controller.params = params

        case path
        when "/"
            controller.index
        when "/index"
            controller.index
        when "/api_index"
            controller.api_index
        else
            controller.not_found
        end
    end
end