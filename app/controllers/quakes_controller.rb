# -*- coding: utf-8 -*-

class QuakesController < ApplicationController

  caches_page :index, :plot, :show

  def index
    @quakes = Quake.where("magnitude != '---'").order('quake_time desc')

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
      format.json { render :json => @quake.to_json }
      format.xml  { render :xml => @quake }
    end
  end

  def plot
    min = Time.at(((params[:min] || 0).to_i - Time.zone.utc_offset)/1000)
    max = Time.at(((params[:max] || 0).to_i - Time.zone.utc_offset)/1000)
regions = Hash[Region.all.map { |r| [ r.id, r.name] }]
    @data = Quake.where("magnitude != '---'").where("quake_time > ? and quake_time < ?", min, max).order(:quake_time).map { |q| [
        (q.quake_time.to_i+Time.zone.utc_offset)*1000, q.magnitude.to_f,
        #url_for(q),
	"/quakes/#{q.id}",
        #"#{l q.quake_time}<br>#{q.region.name}<br>M#{q.magnitude} - #{q.depth}"
        "#{l q.quake_time}<br>#{regions[q.region_id]}<br>M#{q.magnitude} - #{q.depth}"

    ] }

    respond_to do |format|
      format.json { render :json => @data }
    end
  end

end
