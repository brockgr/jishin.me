# -*- coding: utf-8 -*-

class City < ActiveRecord::Base

  include Location

  def name 
    if name_en
      "#{name_en} (#{name_ja})"
    else
      "#{name_ja}"
    end
  end

end
