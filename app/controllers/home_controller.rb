class HomeController < ApplicationController

  def index
    # Subscribers
    @subscribers = Trip.subscribers.count
    @customers = Trip.customers.count
    total = @subscribers + @customers
    @subscribers_percentage = (100 * @subscribers) / total.to_f
    @customers_percentage = (100 * @customers) / total.to_f

    # Time of day
    @morning   = Trip.morning.count
    @afternoon = Trip.afternoon.count
    @evening   = Trip.evening.count
    @night     = Trip.night.count

    total = @morning + @afternoon + @evening + @night
    @morning_percentage = (100 * @morning) / total.to_f
    @afternoon_percentage = (100 * @afternoon) / total.to_f
    @evening_percentage = (100 * @evening) / total.to_f
    @night_percentage = (100 * @night) / total.to_f

    # Rainy days
    rainy_days = Weather.where("precipitation > 0").where(landmark: "San Francisco").pluck(:date)
    rain = Trip.where("DATE(started_at) IN (?)", rainy_days).average(:duration).to_i
    clear = Trip.where("DATE(started_at) NOT IN (?)", rainy_days).average(:duration).to_i

    @rain_minutes = rain / 60.to_i
    @clear_minutes = clear / 60.to_i
    @rain_percentage = (@rain_minutes * 100) / @clear_minutes.to_f
  end
end