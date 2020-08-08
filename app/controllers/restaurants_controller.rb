class RestaurantsController < ApplicationController
  require 'mechanize'

  def index
    @restaurants = Restaurant.all
  end

  def show
  end

  private
  def restaurant_params
  end
end
