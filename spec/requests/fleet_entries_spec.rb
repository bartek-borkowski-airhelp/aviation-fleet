require 'swagger_helper'

RSpec.describe 'Fleet Entries', type: :request do
  let(:Authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("API_USERNAME", "admin"), ENV.fetch("API_PASSWORD", "password")) }

  let!(:manufacturer_record) { Manufacturer.create!(name: 'Boeing', country: 'USA') }
  let!(:family_record) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record) }
  let!(:variant_record) do
    AircraftVariant.create!(
      name: '737-800', iata_code: '738', engine_type: 'turbofan',
      body_type: 'narrowbody', range_category: 'medium', range_km: 5765,
      max_passengers: 189, max_cargo_tonnes: 21.3,
      entry_into_service: '1998-04-22', status: 'active',
      aircraft_family: family_record
    )
  end
  let!(:airline_record) { Airline.create!(name: 'Ryanair', iata_code: 'FR', country: 'Ireland') }

  path '/airlines/{airline_id}/fleet' do
    parameter name: :airline_id, in: :path, type: :integer

    post 'Add a variant to fleet' do
      tags 'Fleet Entries'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :fleet_entry, in: :body, schema: { '$ref' => '#/components/schemas/FleetEntryInput' }

      response '201', 'fleet entry created' do
        schema '$ref' => '#/components/schemas/FleetEntry'

        let(:airline_id) { airline_record.id }
        let(:fleet_entry) do
          { fleet_entry: { aircraft_variant_id: variant_record.id, fleet_count: 50, avg_age_years: 5.2, status: 'active' } }
        end
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:airline_id) { airline_record.id }
        let(:fleet_entry) { { fleet_entry: { aircraft_variant_id: nil, fleet_count: nil } } }
        run_test!
      end
    end
  end

  path '/airlines/{airline_id}/fleet/{id}' do
    parameter name: :airline_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    let!(:entry_record) do
      FleetEntry.create!(airline: airline_record, aircraft_variant: variant_record, fleet_count: 50, avg_age_years: 5.2, status: 'active')
    end

    put 'Update a fleet entry' do
      tags 'Fleet Entries'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :fleet_entry, in: :body, schema: { '$ref' => '#/components/schemas/FleetEntryInput' }

      response '200', 'fleet entry updated' do
        schema '$ref' => '#/components/schemas/FleetEntry'

        let(:airline_id) { airline_record.id }
        let(:id) { entry_record.id }
        let(:fleet_entry) { { fleet_entry: { fleet_count: 75, avg_age_years: 6.1 } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:airline_id) { airline_record.id }
        let(:id) { entry_record.id }
        let(:fleet_entry) { { fleet_entry: { fleet_count: -1 } } }
        run_test!
      end
    end

    delete 'Remove a fleet entry' do
      tags 'Fleet Entries'
      security [ { basicAuth: [] } ]

      response '204', 'fleet entry deleted' do
        let(:airline_id) { airline_record.id }
        let(:id) { entry_record.id }
        run_test!
      end
    end
  end

  path '/airlines/{airline_id}/fleet/{id}/phase-out' do
    parameter name: :airline_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    post 'Phase out a fleet entry' do
      tags 'Fleet Entries'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'fleet entry phased out' do
        schema '$ref' => '#/components/schemas/FleetEntry'

        let(:airline_id) { airline_record.id }
        let!(:entry_record) do
          FleetEntry.create!(airline: airline_record, aircraft_variant: variant_record, fleet_count: 50, avg_age_years: 5.2, status: 'active')
        end
        let(:id) { entry_record.id }
        run_test!
      end
    end
  end
end
