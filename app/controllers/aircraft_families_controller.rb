class AircraftFamiliesController < ApplicationController
  before_action :set_manufacturer, only: %i[index create]
  before_action :set_family, only: %i[show update destroy]

  def index
    render json: @manufacturer.aircraft_families
  end

  def show
    render json: @family
  end

  def create
    family = @manufacturer.aircraft_families.new(family_params)
    if family.save
      render json: family, status: :created
    else
      render json: { errors: family.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @family.update(family_params)
      render json: @family
    else
      render json: { errors: @family.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @family.destroy!
    head :no_content
  end

  private

  def set_manufacturer
    @manufacturer = Manufacturer.find(params[:manufacturer_id])
  end

  def set_family
    @family = AircraftFamily.find(params[:id])
  end

  def family_params
    params.expect(aircraft_family: [ :name ])
  end
end
