class RestaurantsController < ApplicationController
  require 'mechanize'

  def index
    # agent = Mechanize.new
    # page = agent.get("https://tabelog.com/soba/tokyo/rank/")
    # for i in 1..10
    #   element = page.search("#container > div.rstlist-contents.clearfix > div > div.flexible-rstlst-main > ul > li:nth-child(#{i}) > div.list-rst__body > div.list-rst__contents > div > div.list-rst__rst-name-wrap > div.list-rst__rst-name > a")
    #   store_name = element.inner_text
    #   puts store_name
    #   restaurant = Restaurant.new
    #   restaurant.name = store_name
    #   restaurant.save
    # end
    @restaurants = Restaurant.all
  end

  def create
  end

  def show
  end

  private
  def restaurant_params
  end
end
