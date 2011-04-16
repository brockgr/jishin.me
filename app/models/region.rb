# -*- coding: utf-8 -*-

class Region < ActiveRecord::Base

  has_many :quakes

  #has_many :intensities, :as => :location

  include Location


end
