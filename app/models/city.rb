# -*- coding: utf-8 -*-

class City < ActiveRecord::Base

  include Location

  def populate_city_code 
    CityCode.where("city = ?", name_ja).first ||
    CityCode.where("(prefecture || city) = ?", name_ja).first ||
    CityCode.where("(rtrim(prefecture,'県都府') || city) = ?", name_ja).first ||
    CityCode.where("? like ((rtrim(prefecture,'県都府'))||'%') and city like ('%' || ltrim(?,prefecture))", name_ja, name_ja).first ||
    # ken=山形県 city=最上郡金山町  name_ja=山形金山町
    #CityCode.where("? like ((rtrim(prefecture,'県都府'))||'%')", name_ja).first ||
    CityCode.where("replace(city,'市','') = ?", name_ja).first ||
    CityCode.where("city like ?", "%#{name_ja}").first ||
    CityCode.where("? like ('%' || city)", name_ja).first ||
    CityCode.new
  end

end
