class AircraftFamily < ApplicationRecord
  belongs_to :manufacturer
  has_many :aircraft_variants, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :manufacturer_id }
end
