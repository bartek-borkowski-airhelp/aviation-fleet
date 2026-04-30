require 'swagger_helper'

RSpec.describe 'Aircraft Variants', type: :request do
  let(:Authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch("API_USERNAME", "admin"), ENV.fetch("API_PASSWORD", "password")) }

  let!(:manufacturer_record) { Manufacturer.create!(name: 'Boeing', country: 'USA') }
  let!(:family_record) { AircraftFamily.create!(name: '737', manufacturer: manufacturer_record) }

  let(:valid_variant_attrs) do
    {
      name: '737-800', iata_code: '738', engine_type: 'turbofan',
      body_type: 'narrowbody', range_category: 'medium', range_km: 5765,
      max_passengers: 189, max_cargo_tonnes: 21.3,
      entry_into_service: '1998-04-22', status: 'active'
    }
  end

  def create_variant(overrides = {})
    AircraftVariant.create!(valid_variant_attrs.merge(aircraft_family: family_record).merge(overrides))
  end

  path '/families/{family_id}/variants' do
    parameter name: :family_id, in: :path, type: :integer

    get 'List variants for a family' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'variants found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/AircraftVariant' }

        let(:family_id) { family_record.id }
        let!(:variant) { create_variant }
        run_test!
      end
    end

    post 'Create a variant under a family' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :aircraft_variant, in: :body, schema: { '$ref' => '#/components/schemas/AircraftVariantInput' }

      response '201', 'variant created' do
        schema '$ref' => '#/components/schemas/AircraftVariant'

        let(:family_id) { family_record.id }
        let(:aircraft_variant) { { aircraft_variant: valid_variant_attrs } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:family_id) { family_record.id }
        let(:aircraft_variant) { { aircraft_variant: { name: '' } } }
        run_test!
      end
    end
  end

  path '/variants' do
    get 'Search variants' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      produces 'application/json'
      parameter name: :body_type, in: :query, type: :string, required: false,
                enum: %w[narrowbody widebody regional_jet], description: 'Filter by body type'
      parameter name: :engine_type, in: :query, type: :string, required: false,
                enum: %w[turbofan turboprop piston], description: 'Filter by engine type'
      parameter name: :range_category, in: :query, type: :string, required: false,
                enum: %w[short medium long], description: 'Filter by range category'
      parameter name: :min_range_km, in: :query, type: :integer, required: false,
                description: 'Minimum range in km'
      parameter name: :max_passengers, in: :query, type: :integer, required: false,
                description: 'Minimum passenger capacity'
      parameter name: :status, in: :query, type: :string, required: false,
                enum: %w[active discontinued in_development], description: 'Filter by status'

      response '200', 'variants found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/AircraftVariant' }

        let!(:variant) { create_variant }
        run_test!
      end
    end
  end

  path '/variants/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a variant' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'variant found' do
        schema '$ref' => '#/components/schemas/AircraftVariant'

        let(:id) { create_variant.id }
        run_test!
      end

      response '404', 'variant not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a variant' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :aircraft_variant, in: :body, schema: { '$ref' => '#/components/schemas/AircraftVariantInput' }

      response '200', 'variant updated' do
        schema '$ref' => '#/components/schemas/AircraftVariant'

        let(:id) { create_variant.id }
        let(:aircraft_variant) { { aircraft_variant: { max_passengers: 200 } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:id) { create_variant.id }
        let(:aircraft_variant) { { aircraft_variant: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete a variant' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]

      response '204', 'variant deleted' do
        let(:id) { create_variant.id }
        run_test!
      end
    end
  end

  path '/variants/{id}/discontinue' do
    parameter name: :id, in: :path, type: :integer

    post 'Discontinue a variant' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'variant discontinued' do
        schema '$ref' => '#/components/schemas/AircraftVariant'

        let(:id) { create_variant.id }
        run_test!
      end
    end
  end

  path '/variants/{id}/operators' do
    parameter name: :id, in: :path, type: :integer

    get 'List airlines operating this variant' do
      tags 'Aircraft Variants'
      security [ { basicAuth: [] } ]
      produces 'application/json'

      response '200', 'operators found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Airline' }

        let(:id) { create_variant.id }
        run_test!
      end
    end
  end
end
