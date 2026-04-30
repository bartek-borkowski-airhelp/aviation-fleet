require 'swagger_helper'

RSpec.describe 'Aircraft Families', type: :request do
  let(:Authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("API_USERNAME", "admin"), ENV.fetch("API_PASSWORD", "password")) }

  let!(:manufacturer_record) { Manufacturer.create!(name: 'Boeing', country: 'USA') }

  path '/manufacturers/{manufacturer_id}/families' do
    parameter name: :manufacturer_id, in: :path, type: :integer

    get 'List families for a manufacturer' do
      tags 'Aircraft Families'
      security [{ basicAuth: [] }]
      produces 'application/json'

      response '200', 'families found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/AircraftFamily' }

        let(:manufacturer_id) { manufacturer_record.id }
        let!(:family) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record) }
        run_test!
      end
    end

    post 'Create a family under a manufacturer' do
      tags 'Aircraft Families'
      security [{ basicAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :aircraft_family, in: :body, schema: { '$ref' => '#/components/schemas/AircraftFamilyInput' }

      response '201', 'family created' do
        schema '$ref' => '#/components/schemas/AircraftFamily'

        let(:manufacturer_id) { manufacturer_record.id }
        let(:aircraft_family) { { aircraft_family: { name: 'A320' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:manufacturer_id) { manufacturer_record.id }
        let(:aircraft_family) { { aircraft_family: { name: '' } } }
        run_test!
      end
    end
  end

  path '/families/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a family' do
      tags 'Aircraft Families'
      security [{ basicAuth: [] }]
      produces 'application/json'

      response '200', 'family found' do
        schema '$ref' => '#/components/schemas/AircraftFamily'

        let(:id) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record).id }
        run_test!
      end

      response '404', 'family not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a family' do
      tags 'Aircraft Families'
      security [{ basicAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :aircraft_family, in: :body, schema: { '$ref' => '#/components/schemas/AircraftFamilyInput' }

      response '200', 'family updated' do
        schema '$ref' => '#/components/schemas/AircraftFamily'

        let(:id) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record).id }
        let(:aircraft_family) { { aircraft_family: { name: '737 MAX' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:id) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record).id }
        let(:aircraft_family) { { aircraft_family: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a family' do
      tags 'Aircraft Families'
      security [{ basicAuth: [] }]

      response '204', 'family deleted' do
        let(:id) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record).id }
        run_test!
      end
    end
  end
end
