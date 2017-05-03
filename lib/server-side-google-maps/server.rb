require 'httparty'

module ServerSideGoogleMaps
  BASE_URI = 'maps.googleapis.com'

  class Server
    include HTTParty
    base_uri("http://#{BASE_URI}")

    def get(path, params)
      self.class.base_uri("https://#{BASE_URI}") if params[:key]  # if an API token is passed, must use https
      options = { :query => params }
      self.class.get("#{path}/json", options)
    end
  end
end
