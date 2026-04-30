class FleetEntry < ApplicationRecord
  belongs_to :airline
  belongs_to :aircraft_variant

  enum :status, { active: "active", phasing_out: "phasing_out", ordered: "ordered" }

  validates :fleet_count, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :aircraft_variant_id, uniqueness: { scope: :airline_id }
end
