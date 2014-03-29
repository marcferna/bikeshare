class AddIndexes < ActiveRecord::Migration
  def change
    add_index :trips, :start_station_id
    add_index :trips, :end_station_id
    add_index :trips, [:start_station_id, :end_station_id]

    add_index :stations, :landmark
  end
end
