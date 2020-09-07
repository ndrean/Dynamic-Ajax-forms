class ClientsController < ApplicationController

    # on page load, render nothing, and render all if clicked on a
    # button that sends a dummay query string for the controller 
    def index
        if params[:c].present?
            @clients = Client.all.includes(comments: {resto: :genre})
            #@clients = Kaminari.paginate_array(@clients).page(params[:page]).per(3)
            
            #render json: @clients.to_json
            render partial: 'clients/client', collection: @clients, layout: false
            # EQUIVALENT render partial: 'clients/client', locals:{clients: @clients}, layout: false 
        else
            # on page load, render nothing
            @clients = [] #Client.all
            #@clients = Kaminari.paginate_array(@clients).page(params[:page]).per(3)

            #render json: [] #@clients.to_json
        end
    end

end