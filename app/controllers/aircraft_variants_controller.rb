class AircraftVariantsController < ApplicationController
  before_action :set_family, only: %i[nested_index create]
  before_action :set_variant, only: %i[show update destroy discontinue operators]

  # GET /families/:family_id/variants
  def nested_index
    render json: @family.aircraft_variants
  end

  # GET /variants
  def index
    variants = AircraftVariant.all
    variants = variants.where(body_type: params[:body_type]) if params[:body_type].present?
    variants = variants.where(engine_type: params[:engine_type]) if params[:engine_type].present?
    variants = variants.where(range_category: params[:range_category]) if params[:range_category].present?
    variants = variants.where("range_km >= ?", params[:min_range_km]) if params[:min_range_km].present?
    variants = variants.where("max_passengers >= ?", params[:max_passengers]) if params[:max_passengers].present?
    variants = variants.where(status: params[:status]) if params[:status].present?
    render json: variants
  end

  def show
    render json: @variant
  end

  def create
    variant = @family.aircraft_variants.new(variant_params)
    if variant.save
      render json: variant, status: :created
    else
      render json: { errors: variant.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @variant.update(variant_params)
      render json: @variant
    else
      render json: { errors: @variant.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @variant.destroy!
    head :no_content
  end

  # POST /variants/:id/discontinue
  def discontinue
    if @variant.discontinued!
      render json: @variant
    else
      render json: { errors: @variant.errors }, status: :unprocessable_entity
    end
  end

  # GET /variants/:id/operators
  def operators
    render json: @variant.airlines
  end

  private

  def set_family
    @family = AircraftFamily.find(params[:family_id])
  end

  def set_variant
    @variant = AircraftVariant.find(params[:id])
  end

  def variant_params
    params.expect(aircraft_variant: [
      :name, :iata_code, :engine_type, :body_type, :range_category,
      :range_km, :max_passengers, :max_cargo_tonnes, :entry_into_service, :status
    ])
  end
end
