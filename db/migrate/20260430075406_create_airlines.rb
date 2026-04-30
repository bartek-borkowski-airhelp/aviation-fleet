class CreateAirlines < ActiveRecord::Migration[8.1]
  def change
    create_table :airlines do |t|
      t.string :name
      t.string :iata_code
      t.string :country

      t.timestamps
    end
  end
end
