class PagesController < ApplicationController

    def home     
        # for testing cURL, uncomment the following line and go into the console
        # render plain: "You reached the home page, #{request.body.read}" 
    end

    def queries
    end

    # test cURL > curl -X GET -d "qs=Testing reading the queryString" http://localhost:3000/example
    # => >"You reached the home page, qs=Testing reading the queryString"
    # (GET has no payload, just in the query string)
    # => log: 
    #   Started GET "/example" for 127.0.0.1 at 2020-05-23 09:51:32 +0200
    #   Processing by PagesController#home as */*
    #   Parameters: {"qs"=>"Testing reading the queryString"}

end