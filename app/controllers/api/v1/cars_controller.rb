module Api
    module V1
        class CarsController < ApplicationController
            protect_from_forgery only: :put
            def index
                #GET /api/v1/cars
                cars = Car.order('id ASC')
                render json: {status: 'SUCCESS', message: 'Loaded cars', data:cars}, status: :ok
            end

            def show
                #GET /api/v1/cars/:id
                car = Car.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded car', data:car}, status: :ok
            end

            def create
                #POST /api/v1/cars
                car = Car.new(car_params)
                if car.save
                    render json: {status: 'SUCCESS', message: 'Created car', data:car}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Car not created', data:car.errors}, status: :unprocessable_entity
                end
            end

            def destroy
                #POST /api/v1/cars/:id
                car = Car.find(params[:id])
                car.destroy
                render json: {status: 'SUCCESS', message: 'Deleted car', data:car}, status: :ok
            end

            def update
                #PUT /api/v1/cars/:id
                car = Car.find(params[:id])
                if car.update_attributes(car_params)
                    render json: {status: 'SUCCESS', message: 'Updated car', data:car}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Car not updated', data:car.errors}, status: :unprocessable_entity
                end
            end

            private
            def car_params
                params.permit(:year, :make, :model, :color)
            end
        end
    end
end