class ApplicationsController < ApplicationController

    def index 
        @applications = Application.all 
    end

    def show 
        @application = Application.find(params[:id])
        
        if params[:search].present?
            @search_pets = Pet.search(params[:search])
        end
    end

    def new
    end

    def create
        @application = Application.create(application_params)
        @application.status = "in progress"

        if @application.save
            flash[:success] = "Thanks for applying to save a life!"
            redirect_to "/applications/#{@application.id}"
        else 
            flash[:alert] = "Error: #{error_message(@application.errors)}"
            redirect_to "/applications/new"
        end
    end

    def add_pet
        @application = Application.find(params[:id])
        @application.pets << Pet.find(params[:pet_id])
        redirect_to "/applications/#{@application.id}"
    end

    def edit
        @application = Application.find(params[:id])
    end

    def update 
        @application = Application.find(params[:id])
        
        if @application.update(application_params)
            @application.status = "pending"
            @application.save
            redirect_to "/applications/#{@application.id}"
        else
            redirect_to "/applications/#{@application.id}"
            flash[:alert] = "Error: #{error_message(@application.errors)}"
        end
    end

private
    def application_params
        params.permit(:name, :address, :city, :state, :zip, :reason, :status, :pet_id)
    end

end
