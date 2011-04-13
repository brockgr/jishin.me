class City < ActiveRecord::Base

  include Location

  #has_many :intensities, :as => :location

end
