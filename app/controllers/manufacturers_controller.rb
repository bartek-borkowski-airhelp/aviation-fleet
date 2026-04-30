class ManufacturersController < ApplicationController
  before_action :set_manufacturer, only: %i[show update destroy]

  def index
    manufacturers = Manufacturer.all
    manufacturers = manufacturers.where(country: params[:country]) if params[:country].present?
    render json: manufacturers
  end

  def show
    render json: @manufacturer
  end

  def create
    manufacturer = Manufacturer.new(manufacturer_params)
    if manufacturer.save
      render json: manufacturer, status: :created
    else
      render json: { errors: manufacturer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @manufacturer.update(manufacturer_params)
      render json: @manufacturer
    else
      render json: { errors: @manufacturer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @manufacturer.destroy!
    head :no_content
  end

  private

  def set_manufacturer
    @manufacturer = Manufacturer.find(params[:id])
  end

  def manufacturer_params
    params.expect(manufacturer: [:name, :country])
  end
end
