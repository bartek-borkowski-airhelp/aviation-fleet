class AircraftVariant < ApplicationRecord
  belongs_to :aircraft_family
  has_many :fleet_entries, dependent: :destroy
  has_many :airlines, through: :fleet_entries

  enum :engine_type, { turbofan: "turbofan", turboprop: "turboprop", piston: "piston", propeller: "propeller" }
  enum :body_type, { narrowbody: "narrowbody", widebody: "widebody", regional_jet: "regional_jet", biplane: "biplane" }
  enum :range_category, { short: "short", medium: "medium", long: "long" }
  enum :status, { active: "active", discontinued: "discontinued", in_development: "in_development" }

  validates :name, presence: true
  validates :iata_code, presence: true
  validates :engine_type, presence: true
  validates :body_type, presence: true
  validates :range_category, presence: true
  validates :range_km, presence: true, numericality: { greater_than: 0 }
  validates :max_passengers, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
end
