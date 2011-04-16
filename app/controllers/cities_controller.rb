# -*- coding: utf-8 -*-

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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @city.intensities.to_json(:only => [:value], :methods => [:time]) }
      format.xml  { render :xml => @city }
    end
  end

  def plot
    min = Time.at(((params[:min] || 0).to_i - Time.zone.utc_offset)/1000)
    max = Time.at(((params[:max] || 0).to_i - Time.zone.utc_offset)/1000)
    @data = City.find(params[:id]).intensities.includes(:quake).where("quakes.quake_time > ? and quakes.quake_time < ?", min, max).order("quakes.quake_time").map do |i|
      [ (i.quake.quake_time.to_i+Time.zone.utc_offset)*1000, i.value.to_f, url_for(i.quake) ]
    end

    respond_to do |format|
      format.json { render :json => @data.to_json }
    end
  end


end
