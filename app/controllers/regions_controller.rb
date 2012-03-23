# -*- coding: utf-8 -*-

class RegionsController < ApplicationController
  caches_page :plot, :show

  def index
    @regions = Region.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regions }
    end
  end

  def show
    @region = Region.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @region }
    end
  end

end
