require 'swagger_helper'

RSpec.describe 'Airlines', type: :request do
  let(:Authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("API_USERNAME", "admin"), ENV.fetch("API_PASSWORD", "password")) }

  path '/airlines' do
    get 'List airlines' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]
      produces 'application/json'
      parameter name: :country, in: :query, type: :string, required: false, description: 'Filter by country'
      parameter name: :iata_code, in: :query, type: :string, required: false, description: 'Filter by IATA code'

      response '200', 'airlines found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Airline' }

        let!(:airline) { Airline.create!(name: 'Ryanair', iata_code: 'FR', country: 'Ireland') }
        run_test!
      end
    end

    post 'Create an airline' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :airline, in: :body, schema: { '$ref' => '#/components/schemas/AirlineInput' }

      response '201', 'airline created' do
        schema '$ref' => '#/components/schemas/Airline'

        let(:airline) { { airline: { name: 'Lufthansa', iata_code: 'LH', country: 'Germany' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:airline) { { airline: { name: '', iata_code: '', country: '' } } }
        run_test!
      end
    end
  end

  path '/airlines/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve an airline' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'airline found' do
        schema '$ref' => '#/components/schemas/Airline'

        let(:id) { Airline.create!(name: 'Emirates', iata_code: 'EK', country: 'UAE').id }
        run_test!
      end

      response '404', 'airline not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update an airline' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :airline, in: :body, schema: { '$ref' => '#/components/schemas/AirlineInput' }

      response '200', 'airline updated' do
        schema '$ref' => '#/components/schemas/Airline'

        let(:id) { Airline.create!(name: 'Emirates', iata_code: 'EK', country: 'UAE').id }
        let(:airline) { { airline: { name: 'Emirates Airlines' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:id) { Airline.create!(name: 'Emirates', iata_code: 'EK', country: 'UAE').id }
        let(:airline) { { airline: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete an airline' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]

      response '204', 'airline deleted' do
        let(:id) { Airline.create!(name: 'Emirates', iata_code: 'EK', country: 'UAE').id }
        run_test!
      end
    end
  end

  path '/airlines/{id}/fleet' do
    parameter name: :id, in: :path, type: :integer

    get 'List fleet entries for an airline' do
      tags 'Airlines'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'fleet entries found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/FleetEntry' }

        let(:id) { Airline.create!(name: 'Ryanair', iata_code: 'FR', country: 'Ireland').id }
        run_test!
      end
    end
  end
end
