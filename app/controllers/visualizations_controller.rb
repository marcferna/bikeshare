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
end