class Manufacturer < ApplicationRecord
  has_many :aircraft_families, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
end
