class RestaurantsController < ApplicationController
  require 'mechanize'

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end
