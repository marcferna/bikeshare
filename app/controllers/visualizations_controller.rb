class VisualizationsController < ApplicationController

  def chord_data
    stations = Station.where(landmark: "San Francisco")
    @stations_data = []
    stations.each_with_index do |station, index|
      color = "%06x" % (rand * 0xffffff)
      @stations_data << {
        id:    index,
        color: color,
        data:  color,
        name:  station.name
      }
    end

    @matrix = []
    stations.each do |start_station|
      trips = []
      stations.each do |end_station|
        trips << Trip.where(start_station_id: start_station).where(end_station_id: end_station).count
      end
      @matrix << trips
    end

    render json: {mmap: @stations_data, matrix: @matrix}
  end

  def heat_map_data
    trips = Trip.group("WEEKDAY(started_at)").group("HOUR(started_at)").count
    @matrix = []
    trips.each do |value|
      @matrix << {
        day:   value[0][0] + 1,
        hour:  value[0][1] + 1,
        value: value[1],
      }
    end
    render json: @matrix and return
  end

  def subscriptors
    subscribers     = Trip.subscribers.count
    non_subscribers = Trip.customers.count
    render json: [
      { label: "Subscribers", value: subscribers },
      { label: "Customers", value: non_subscribers }
    ]
  end

  def time_of_day
    morning = Trip.morning.count
    afternoon = Trip.afternoon.count
    evening = Trip.evening.count
    night = Trip.night.count
    render json: [
      { label: "Morning", value: morning },
      { label: "Afternoon", value: afternoon },
      { label: "Evening", value: evening },
      { label: "Night", value: night }
    ]
  end

  def rainy_days
    rainy_days = Weather.where("precipitation > 0").where(landmark: "San Francisco").pluck(:date)
    rain = Trip.where("DATE(started_at) IN (?)", rainy_days).average(:duration).to_i
    clear = Trip.where("DATE(started_at) NOT IN (?)", rainy_days).average(:duration).to_i
    render json: [
      { label: "Rain", value: rain },
      { label: "No Rain", value: clear }
    ]
  end
end