module Location

  def intensities 
    Intensity.where(:location_id => self.id, :location_type => self.class).includes(:quake).order("quakes.quake_time")
  end

end
