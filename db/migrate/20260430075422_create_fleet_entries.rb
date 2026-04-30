class CreateFleetEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :fleet_entries do |t|
      t.references :airline, null: false, foreign_key: true
      t.references :aircraft_variant, null: false, foreign_key: true
      t.integer :fleet_count
      t.float :avg_age_years
      t.string :status

      t.timestamps
    end
  end
end
