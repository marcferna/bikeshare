class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :trip_id
      t.integer :duration
      t.datetime :started_at
      t.integer :start_station_id
      t.datetime :ended_at
      t.integer :end_station_id
      t.integer :bike_id
      t.integer :subscription_type
      t.integer :zip_code
    end
  end
end
