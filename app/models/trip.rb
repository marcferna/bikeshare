class Trip < ActiveRecord::Base

  ## Relationships
  belongs_to :start_station, foreign_key: :start_station_id, class_name: Station
  belongs_to :end_station, foreign_key: :end_station_id, class_name: Station

  ## Constants
  SUBSCRIPTION_TYPE = HashWithIndifferentAccess.new ({
    customer:   0,
    subscriber: 1
  })
end
