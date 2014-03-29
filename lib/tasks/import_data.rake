require 'csv'

desc "Import the data into the DB"
task :import_data => :environment do
  ActiveRecord::Base.connection.execute("TRUNCATE trips")
  ActiveRecord::Base.connection.execute("TRUNCATE stations")

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
end