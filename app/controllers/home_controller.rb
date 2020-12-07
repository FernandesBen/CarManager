class HomeController < ApplicationController
    def index
        @cars = Car.all
    end

    def new
    end

    def create
        Car.create({
            year: params[:year],
            make: params[:make],
            model: params[:model],
            color: params[:color]
        })
        redirect_to root_path
    end

    def delete
        Car.find(params[:id]).destroy
        redirect_to root_path
    end
end