class HomeController < ApplicationController

  def index
    # Subscribers
    @subscribers = Trip.where(start_station_id: @stations).subscribers.count
    @customers = Trip.where(start_station_id: @stations).customers.count
    total = @subscribers + @customers
    @subscribers_percentage = (100 * @subscribers) / total.to_f
    @customers_percentage = (100 * @customers) / total.to_f

    # Time of day
    @morning   = Trip.where(start_station_id: @stations).morning.count
    @afternoon = Trip.where(start_station_id: @stations).afternoon.count
    @evening   = Trip.where(start_station_id: @stations).evening.count
    @night     = Trip.where(start_station_id: @stations).night.count

    total = @morning + @afternoon + @evening + @night
    @morning_percentage = (100 * @morning) / total.to_f
    @afternoon_percentage = (100 * @afternoon) / total.to_f
    @evening_percentage = (100 * @evening) / total.to_f
    @night_percentage = (100 * @night) / total.to_f

    # Rainy days
    if @selected_city == "All cities"
      rainy_days = Weather.where("precipitation > 0").pluck(:date)
    else
      rainy_days = Weather.where("precipitation > 0").where(landmark: @selected_city).pluck(:date)
    end
    rain = Trip.where(start_station_id: @stations).where("DATE(started_at) IN (?)", rainy_days).average(:duration).to_i
    clear = Trip.where(start_station_id: @stations).where("DATE(started_at) NOT IN (?)", rainy_days).average(:duration).to_i

    @rain_minutes = rain / 60.to_i
    @clear_minutes = clear / 60.to_i
    @rain_percentage = (@rain_minutes * 100) / @clear_minutes.to_f

    # stats
    @bikes_count = Trip.where(start_station_id: @stations).count(:bike_id, distinct: true)
    bikes_trip_count = Trip.where(start_station_id: @stations).group(:bike_id).order("count_all DESC").count.to_a
    @most_used_bike = bikes_trip_count.first.first
    @least_used_bike = bikes_trip_count.last.first

    @stations_count = @stations.count
    stations_started_count = Trip.where(start_station_id: @stations).group(:start_station_id).order("count_all DESC").count.to_a
    @most_station_started = Station.find_by_id(stations_started_count.first.first)
    @least_station_started = Station.find_by_id(stations_started_count.last.first)

    @trips_count = Trip.where(start_station_id: @stations).count
    @average_travel_time = Trip.where(start_station_id: @stations).average(:duration).to_f / 60
    @longest_trip = Trip.where(start_station_id: @stations).order(:duration).last.duration.to_f / 60

  end

  def ping
    render json: {
       status: "ok"
    } and return
  end
end