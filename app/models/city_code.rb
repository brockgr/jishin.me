# -*- coding: utf-8 -*-

class CityCode < ActiveRecord::Base

  def self.find_by_name_ja(city)
    name_ja = city.respond_to?(:name_ja) ? city.name_ja : city.to_s

    return CityCode.where("city = ?", name_ja).first ||
      CityCode.where("(prefecture || city) = ?", name_ja).first ||
      CityCode.where("(rtrim(prefecture,'県都府') || city) = ?", name_ja).first ||
      CityCode.where("? like ((rtrim(prefecture,'県都府'))||'%') and city like ('%' || ltrim(?,prefecture))", name_ja, name_ja).first ||
      CityCode.where("replace(city,'市','') = ?", name_ja).first ||
      CityCode.where("city like ?", "%#{name_ja}").first ||
      CityCode.where("? like ('%' || city)", name_ja).first 
  end

end
