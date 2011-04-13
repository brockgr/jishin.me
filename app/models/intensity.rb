class Intensity < ActiveRecord::Base
  belongs_to :quake
  belongs_to :location, :polymorphic => true

  def time
    self.quake.quake_time
  end

  def location_ja
    self.location.name_ja
  end

end
