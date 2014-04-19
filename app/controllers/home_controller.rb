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
  end
end