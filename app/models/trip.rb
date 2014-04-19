class Trip < ActiveRecord::Base

  ## Relationships
  belongs_to :start_station, foreign_key: :start_station_id, class_name: Station
  belongs_to :end_station, foreign_key: :end_station_id, class_name: Station

  ## Constants
  SUBSCRIPTION_TYPE = HashWithIndifferentAccess.new ({
    customer:   0,
    subscriber: 1
  })

  ## Scopes
  scope :subscribers, -> { where(subscription_type: Trip::SUBSCRIPTION_TYPE[:subscriber]) }
  scope :customers,   -> { where(subscription_type: Trip::SUBSCRIPTION_TYPE[:customer]) }

  scope :morning,   -> { where("TIME(started_at) BETWEEN '06:00:01' AND '12:00:00'") }
  scope :afternoon, -> { where("TIME(started_at) BETWEEN '12:00:01' AND '17:00:00'") }
  scope :evening,   -> { where("TIME(started_at) BETWEEN '17:00:01' AND '20:00:00'") }
  scope :night,     -> { where("TIME(started_at) > '20:00:00' OR TIME(started_at) <= '06:00:00'") }
end
