CarManager Documentation
Requirements
-home page
    -view all cars in inventory
    -all cars displayed in table
    -delete car button in each table row
    -button to navigate to add car page
-add car page
    -add car
    -form to submit
    -button to navigate to home page

Setup Application
-Create Application
    rails new CarManager -d postgresql
    cd CarManager
    -add haml gem
        -modify Gemfile
            gem 'haml-rails'
    bundle install
    rake db:create
-Setup Migration
    rails generate migration CreateCars
    -modify db/migrate/20201207043403_create_cars.rb
        class CreateCars < ActiveRecord::Migration[5.2]
            def change
                create_table :cars do |t|
                t.integer :year
                t.string :make
                t.string :model
                t.string :color

                t.timestamps
                end
            end
        end
    rake db:migrate
-Website Setup
    -Setup models
        -create app/models/car.rb
            class Car < ApplicationRecord
            end
    -Setup routes
        -modify config/routes.rb
            Rails.application.routes.draw do
                root 'home#index'
                get 'new' => 'home#new'
                post 'create' => 'home#create'
                delete 'delete/:id' => 'home#delete'
                get 'update/:id' => 'home#update'
                put 'update/:id' => 'home#save'
                
                namespace 'api' do
                    namespace 'v1' do
                        get 'cars' => 'cars#index'
                        post 'cars' => 'cars#create'
                        get 'cars/:id' => 'cars#show'
                        delete 'cars/:id' => 'cars#destroy'
                        put 'cars/:id' => 'cars#update'
                    end
                end
            end

    -Setup Controllers
        -create app/controllers/home_controller.rb
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

                def update
                    @car = Car.find(params[:id])
                end


                def update
                    @car = Car.find(params[:id])
                end

                def save
                    car = Car.find(params[:id])
                    car.update({
                        year: params[:year],
                        make: params[:make],
                        model: params[:model],
                        color: params[:color]
                    })
                    if car.save
                        redirect_to root_path
                    else
                        redirect_to "/update/#{params[:id]}"
                    end
                end
            end
        -setting up api controller: create app/assets/controllers/api/v1/cars_controller.rb
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

    -Setup Views
        -create app/views/home/index.html.erb
            <h2>Welcome to Car Manager</h2>
            <%= link_to "Add Car", new_path %>
            <br>
            <br>
            <table>
                <colgroup>
                    <col span="1" style="width: 20%;">
                    <col span="1" style="width: 20%;">
                    <col span="1" style="width: 20%;">
                    <col span="1" style="width: 20%;">
                    <col span="1" style="width: 20%;">
                <colgroup>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Year</th>
                        <th>Make</th>
                        <th>Model</th>
                        <th>Color</th>
                    </tr>
                </thead>
                <tbody>
                    <% @cars.each do |car| %>
                        <tr>
                            <td><%= car.id  %></td>
                            <td><%= car.year %></td>
                            <td><%= car.make %></td>
                            <td><%= car.model %></td>
                            <td><%= car.color %></td>
                            <td style="border: none"><%= link_to 'Update', "update/#{car.id}" %></td>
                            <td style="border: none"><%= link_to 'Delete', "delete/#{car.id}", :method => :delete  %></td>
                        </tr>
                    <% end %>
                </tbody>
            </table>
        -create app/views/home/new.html.erb
            <h2>Add Car</h2>
            <%= link_to "All Cars", root_path %>

            <%= form_tag create_path do %>
                <div>
                    <%= label_tag :year, "Year" %>
                    <%= number_field_tag :year %>
                </div>
                <div>
                    <%= label_tag :make, "Make" %>
                    <%= text_field_tag :make %>
                <div>
                <div>
                    <%= label_tag :model, "Model" %>
                    <%= text_field_tag :model %>
                <div>
                <div>
                    <%= label_tag :color, "Color" %>
                    <%= text_field_tag :color %>
                </div>
                <div>
                    <%= submit_tag "Submit" %>
                </div>
            <% end %>
        -create app/views/home/update.html.haml
            %h2= "Update Content"

                = form_tag "/update/#{@car.id}", method: :put do
                    %div
                        %label Year
                        %input{:name => 'year', :type => 'number',:value => @car.year}
                    %div
                        %label Make
                        %input{:name => 'make', :type => 'text',:value => @car.make}
                    %div
                        %label Model
                        %input{:name => 'model', :type => 'text',:value => @car.model}
                    %div
                        %label Color
                        %input{:name => 'color', :type => 'text',:value => @car.color}
                    = submit_tag "Update"

    -Setup stylesheets
        -create app/stylesheets/index.css
            table {
                width: 80%;
                text-align: center;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid black;
            }




Improvements
-Rewrite in HAML
-Rewrite to be RESTful
-Style it up