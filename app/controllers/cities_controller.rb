# -*- coding: utf-8 -*-


class CitiesController < ApplicationController

  caches_page :show

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => City.all }
      format.xml  { render :xml => City.all }
    end
  end

  def show
    @city = City.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @city.intensities.to_json(:only => [:value], :methods => [:time]) }
      format.xml  { render :xml => @city.intensities }
    end
  end

  def plot
    min = Time.at(((params[:min] || 0).to_i - Time.zone.utc_offset)/1000)
    max = Time.at(((params[:max] || 0).to_i - Time.zone.utc_offset)/1000)
    @data = City.find(params[:id]).intensities.includes(:quake).where("quakes.quake_time > ? and quakes.quake_time < ?", min, max).order("quakes.quake_time").map { |i| [
        (i.quake.quake_time.to_i+Time.zone.utc_offset)*1000,
        i.value_i,
        url_for(i.quake),
        "#{l i.quake.quake_time}<br>#{i.quake.region.name}<br>M#{i.quake.magnitude} - #{i.quake.depth}"
    ] }
    respond_to do |format|
      format.json { render :json => @data }
    end
  end

  def search
    term = params[:term]
    @data = City.where("lower(name_en) like ? or lower(name_ja) like ?", "%#{term.downcase}%", "%#{term.downcase}%").all.map do |c|
      { :id => c.id, :label => c.name  }
    end
    respond_to do |format|
      format.json { render :json => @data }
    end
  end


end
