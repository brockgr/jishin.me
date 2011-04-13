class QuakesController < ApplicationController
  def index
    @quakes = Quake.where("magnitude != '---'").order(:quake_time)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @quakes.to_json }
      format.xml  { render :xml => @quakes }
    end
  end

  def show
    @quake = Quake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @quake.intensities.includes(:location).to_json(:only => [:value], :methods => [:location_ja]) }
      format.xml  { render :xml => @quake }
    end
  end

end
