class Station < ActiveRecord::Base

  def self.cities
    Station.all.uniq.pluck(:landmark)
  end
end
