# -*- coding: utf-8 -*-

class Region < ActiveRecord::Base

  has_many :quakes

  include Location

  def name
    if name_en
      "#{name_en} (#{name_ja})"
    else
      "#{name_ja}"
    end
  end

end
