require 'csv'

desc "Import the data into the DB"
task :import_data => :environment do
  ActiveRecord::Base.connection.execute("TRUNCATE trips")
  ActiveRecord::Base.connection.execute("TRUNCATE stations")
  ActiveRecord::Base.connection.execute("TRUNCATE weathers")

  file = "db/csv/201402_station_data.csv"
  CSV.foreach(file, headers: true) do |row|
    Station.create!(
      station_id:   row[0],
      name:         row[1],
      lat:          row[2],
      lng:          row[3],
      dock_count:   row[4],
      landmark:     row[5],
      installed_at: Date.strptime(row[6],"%m/%d/%Y"),
    )
  end

  file = "db/csv/201402_trip_data.csv"
  CSV.foreach(file, headers: true) do |row|
    begin
      Trip.create!(
        trip_id:           row[0],
        duration:          row[1],
        started_at:        DateTime.strptime(row[2], "%m/%d/%Y %k:%M"),
        start_station_id:  (Station.find_by(name: row[3]) || Station.find_by(station_id: row[4])).id,
        ended_at:          DateTime.strptime(row[5], "%m/%d/%Y %k:%M"),
        end_station_id:    (Station.find_by(name: row[6]) || Station.find_by(station_id: row[7])).id,
        bike_id:           row[8],
        subscription_type: Trip::SUBSCRIPTION_TYPE[row[9].downcase],
        zip_code:          row[10]
      )
    rescue => e
      puts "Could not create trip #{row[0]}"
    end
  end

  file = "db/csv/201402_weather_data.csv"
  CSV.foreach(file, headers: true) do |row|
    begin
      landmark = case row[23]
      when "94107"
        "San Francisco"
      when "94063"
        "Redwood City"
      when "94301"
        "Palo Alto"
      when "94041"
        "Mountain View"
      when "95113"
        "San Jose"
      end
      p row[19].to_f
      Weather.create!(
        date:              Date.strptime(row[0],"%m/%d/%Y"),
        max_temperature:   row[1],
        mean_temperature:  row[2],
        min_temperature:   row[3],
        precipitation:     (row[19] == "T" ? 0 : row[19].to_f),
        cloud_cover:       row[20],
        event:             row[21],
        landmark:          landmark
      )
    rescue => e
      puts "Could not create weather #{row[0]}"
    end
  end
end