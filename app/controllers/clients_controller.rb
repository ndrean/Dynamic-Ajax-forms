class ClientsController < ApplicationController

    # on page load, render nothing, and render all if clicked on a
    # button that sends a dummay query string for the controller 
    def index
        if params[:c].present?
            puts params[:c].present?
            @clients = Client.all.includes(comments: {resto: :genre})
            #render json: @clients.to_json
            render partial: 'clients/client', collection: @clients, layout: false
            #render partial: 'clients/client', locals:{clients: @clients}, layout: false EQUIVALENT
        else
            # on page load, render nothing
            @clients = []
            #render json: [] #@clients.to_json
        end
    end

end