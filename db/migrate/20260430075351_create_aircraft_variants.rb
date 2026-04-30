class CreateAircraftVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :aircraft_variants do |t|
      t.string :name
      t.string :iata_code
      t.string :engine_type
      t.string :body_type
      t.string :range_category
      t.integer :range_km
      t.integer :max_passengers
      t.float :max_cargo_tonnes
      t.date :entry_into_service
      t.string :status
      t.references :aircraft_family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
