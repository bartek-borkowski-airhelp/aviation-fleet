class AirlinesController < ApplicationController
  before_action :set_airline, only: %i[show update destroy fleet]

  def index
    airlines = Airline.all
    airlines = airlines.where(country: params[:country]) if params[:country].present?
    airlines = airlines.where(iata_code: params[:iata_code]) if params[:iata_code].present?
    render json: airlines
  end

  def show
    render json: @airline
  end

  def create
    airline = Airline.new(airline_params)
    if airline.save
      render json: airline, status: :created
    else
      render json: { errors: airline.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @airline.update(airline_params)
      render json: @airline
    else
      render json: { errors: @airline.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @airline.destroy!
    head :no_content
  end

  # GET /airlines/:id/fleet
  def fleet
    render json: @airline.fleet_entries
  end

  private

  def set_airline
    @airline = Airline.find(params[:id])
  end

  def airline_params
    params.expect(airline: [:name, :iata_code, :country])
  end
end
