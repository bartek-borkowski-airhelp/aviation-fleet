class Airline < ApplicationRecord
  has_many :fleet_entries, dependent: :destroy
  has_many :aircraft_variants, through: :fleet_entries

  validates :name, presence: true
  validates :iata_code, presence: true, uniqueness: true, length: { is: 2 }
  validates :country, presence: true
end
