require 'swagger_helper'

RSpec.describe 'Manufacturers', type: :request do
  let(:Authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("API_USERNAME", "admin"), ENV.fetch("API_PASSWORD", "password")) }

  path '/manufacturers' do
    get 'List manufacturers' do
      tags 'Manufacturers'
      security [{ basicAuth: [] }]
      produces 'application/json'
      parameter name: :country, in: :query, type: :string, required: false, description: 'Filter by country'

      response '200', 'manufacturers found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Manufacturer' }

        let!(:manufacturer) { Manufacturer.create!(name: 'Boeing', country: 'USA') }
        run_test!
      end
    end

    post 'Create a manufacturer' do
      tags 'Manufacturers'
      security [{ basicAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :manufacturer, in: :body, schema: { '$ref' => '#/components/schemas/ManufacturerInput' }

      response '201', 'manufacturer created' do
        schema '$ref' => '#/components/schemas/Manufacturer'

        let(:manufacturer) { { manufacturer: { name: 'Airbus', country: 'France' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:manufacturer) { { manufacturer: { name: '', country: '' } } }
        run_test!
      end
    end
  end

  path '/manufacturers/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a manufacturer' do
      tags 'Manufacturers'
      security [{ basicAuth: [] }]
      produces 'application/json'

      response '200', 'manufacturer found' do
        schema '$ref' => '#/components/schemas/Manufacturer'

        let(:id) { Manufacturer.create!(name: 'Embraer', country: 'Brazil').id }
        run_test!
      end

      response '404', 'manufacturer not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a manufacturer' do
      tags 'Manufacturers'
      security [{ basicAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :manufacturer, in: :body, schema: { '$ref' => '#/components/schemas/ManufacturerInput' }

      response '200', 'manufacturer updated' do
        schema '$ref' => '#/components/schemas/Manufacturer'

        let(:id) { Manufacturer.create!(name: 'Boeing', country: 'USA').id }
        let(:manufacturer) { { manufacturer: { name: 'Boeing Co.' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:id) { Manufacturer.create!(name: 'Boeing', country: 'USA').id }
        let(:manufacturer) { { manufacturer: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a manufacturer' do
      tags 'Manufacturers'
      security [{ basicAuth: [] }]

      response '204', 'manufacturer deleted' do
        let(:id) { Manufacturer.create!(name: 'Boeing', country: 'USA').id }
        run_test!
      end
    end
  end
end
