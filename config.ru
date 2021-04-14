require "rack"
require "rack/cors"
require "thin"

load "router.rb"

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

use Rack::Static, :root => "public", :urls => ["/css", "/js", "/images"]

handler = Rack::Handler::Thin
handler.run(
  Router.new,
  Port: 7373,
)