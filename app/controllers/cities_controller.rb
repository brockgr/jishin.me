class CitiesController < ApplicationController
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render  :json => @cities.to_json }
      format.xml  { render :xml => @cities }
    end
  end

  def show
    @city = City.find(params[:id])

 ActiveRecord::Base.include_root_in_json = false
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @city.intensities.to_json(:only => [:value], :methods => [:time]) }
      format.xml  { render :xml => @city }
    end
  end

end
