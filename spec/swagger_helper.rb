# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Aviation Fleet API',
        version: 'v1',
        description: 'API for managing aircraft manufacturers, families, variants, airlines, and fleet entries'
      },
      paths: {},
      security: [ { basicAuth: [] } ],
      servers: [
        {
          url: '{protocol}://{host}',
          variables: {
            protocol: { default: 'http', enum: %w[http https] },
            host: { default: 'localhost:3000' }
          }
        }
      ],
      components: {
        schemas: {
          Manufacturer: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              country: { type: :string },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            },
            required: %w[id name country]
          },
          ManufacturerInput: {
            type: :object,
            properties: {
              manufacturer: {
                type: :object,
                properties: {
                  name: { type: :string },
                  country: { type: :string }
                },
                required: %w[name country]
              }
            },
            required: %w[manufacturer]
          },
          AircraftFamily: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              manufacturer_id: { type: :integer },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            },
            required: %w[id name manufacturer_id]
          },
          AircraftFamilyInput: {
            type: :object,
            properties: {
              aircraft_family: {
                type: :object,
                properties: {
                  name: { type: :string }
                },
                required: %w[name]
              }
            },
            required: %w[aircraft_family]
          },
          AircraftVariant: {
            type: :object,
            properties: {
              id: { type: :integer },
              aircraft_family_id: { type: :integer },
              name: { type: :string },
              iata_code: { type: :string },
              engine_type: { type: :string, enum: %w[turbofan turboprop piston propeller] },
              body_type: { type: :string, enum: %w[narrowbody widebody regional_jet biplane] },
              range_category: { type: :string, enum: %w[short medium long] },
              range_km: { type: :integer },
              max_passengers: { type: :integer },
              max_cargo_tonnes: { type: :number, format: :float, nullable: true },
              entry_into_service: { type: :string, format: :date, nullable: true },
              status: { type: :string, enum: %w[active discontinued in_development] },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            },
            required: %w[id aircraft_family_id name iata_code engine_type body_type range_category range_km max_passengers status]
          },
          AircraftVariantInput: {
            type: :object,
            properties: {
              aircraft_variant: {
                type: :object,
                properties: {
                  name: { type: :string },
                  iata_code: { type: :string },
                  engine_type: { type: :string, enum: %w[turbofan turboprop piston propeller] },
                  body_type: { type: :string, enum: %w[narrowbody widebody regional_jet biplane] },
                  range_category: { type: :string, enum: %w[short medium long] },
                  range_km: { type: :integer },
                  max_passengers: { type: :integer },
                  max_cargo_tonnes: { type: :number, format: :float },
                  entry_into_service: { type: :string, format: :date },
                  status: { type: :string, enum: %w[active discontinued in_development] }
                },
                required: %w[name iata_code engine_type body_type range_category range_km max_passengers status]
              }
            },
            required: %w[aircraft_variant]
          },
          Airline: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              iata_code: { type: :string },
              country: { type: :string },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            },
            required: %w[id name iata_code country]
          },
          AirlineInput: {
            type: :object,
            properties: {
              airline: {
                type: :object,
                properties: {
                  name: { type: :string },
                  iata_code: { type: :string },
                  country: { type: :string }
                },
                required: %w[name iata_code country]
              }
            },
            required: %w[airline]
          },
          FleetEntry: {
            type: :object,
            properties: {
              id: { type: :integer },
              airline_id: { type: :integer },
              aircraft_variant_id: { type: :integer },
              fleet_count: { type: :integer },
              avg_age_years: { type: :number, format: :float, nullable: true },
              status: { type: :string, enum: %w[active phasing_out ordered] },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            },
            required: %w[id airline_id aircraft_variant_id fleet_count status]
          },
          FleetEntryInput: {
            type: :object,
            properties: {
              fleet_entry: {
                type: :object,
                properties: {
                  aircraft_variant_id: { type: :integer },
                  fleet_count: { type: :integer },
                  avg_age_years: { type: :number, format: :float },
                  status: { type: :string, enum: %w[active phasing_out ordered] }
                },
                required: %w[aircraft_variant_id fleet_count status]
              }
            },
            required: %w[fleet_entry]
          },
          Errors: {
            type: :object,
            properties: {
              errors: { type: :object }
            }
          }
        },
        securitySchemes: {
          basicAuth: {
            type: :http,
            scheme: :basic
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
