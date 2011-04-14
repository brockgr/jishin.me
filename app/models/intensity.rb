class Intensity < ActiveRecord::Base
  belongs_to :quake
  belongs_to :location, :polymorphic => true

  def time
    self.quake ? self.quake.quake_time : "No Quake #{self.quake_id.inspect}#!"
  end

  def location_ja
    self.location.name_ja
  end

  def value_i
    case value
      when "1" then 1
      when "2" then 2
      when "3" then 3
      when "4" then 4
      when "5-" then 5
      when "5+" then 6
      when "6-" then 7
      when "6+" then 8
      when "7" then 9
    end
  end

end
