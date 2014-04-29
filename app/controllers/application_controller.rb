class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :select_city, except: :ping

  private

    def select_city
      @cities = Station.cities
      if params["city"] == "All cities"
        @selected_city = "All cities"
        @stations = Station.all
      else
        @selected_city = params["city"] || "San Francisco"
        @stations = Station.where(landmark: @selected_city)
      end
    end
end
