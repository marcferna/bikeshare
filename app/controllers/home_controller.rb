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
  end
end