class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.date :date
      t.integer :max_temperature
      t.integer :mean_temperature
      t.integer :min_temperature
      t.decimal :precipitation, precision: 4, scale: 3
      t.integer :cloud_cover
      t.string :event
      t.string :landmark

      t.timestamps
    end
  end
end
