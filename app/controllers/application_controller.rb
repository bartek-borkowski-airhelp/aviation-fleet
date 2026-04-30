class ApplicationController < ActionController::API
  http_basic_authenticate_with name: ENV.fetch("API_USERNAME", "admin"),
                                password: ENV.fetch("API_PASSWORD", "password")
end
