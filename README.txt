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

Steps to Create
-Create Application
    rails new CarManager -d postgresql
    cd CarManager
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
        end
    -create app/models/car.rb
        class Car < ApplicationRecord
        end
    -create app/views/home/index.html.erb
        <h2>Welcome to Car Manager</h2>
        <%= link_to "Add Car", new_path %>

        <table>
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
                        <td><%= link_to 'Delete', "delete/#{car.id}", :method => :delete  %></td>
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
    -modify config/routes.rb
        Rails.application.routes.draw do
            root 'home#index'
            get 'new' => 'home#new'
            post 'create' => 'home#create'
            delete 'delete/:id' => 'home#delete'
        end


Improvements
-Add API
-Add update functionality
-Rewrite in HAML
-Rewrite to be RESTful
-Style it up
