class FleetEntriesController < ApplicationController
  before_action :set_airline
  before_action :set_fleet_entry, only: %i[update destroy phase_out]

  # POST /airlines/:airline_id/fleet
  def create
    entry = @airline.fleet_entries.new(fleet_entry_params)
    if entry.save
      render json: entry, status: :created
    else
      render json: { errors: entry.errors }, status: :unprocessable_entity
    end
  end

  # PUT /airlines/:airline_id/fleet/:id
  def update
    if @fleet_entry.update(fleet_entry_params)
      render json: @fleet_entry
    else
      render json: { errors: @fleet_entry.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /airlines/:airline_id/fleet/:id
  def destroy
    @fleet_entry.destroy!
    head :no_content
  end

  # POST /airlines/:airline_id/fleet/:id/phase-out
  def phase_out
    if @fleet_entry.phasing_out!
      render json: @fleet_entry
    else
      render json: { errors: @fleet_entry.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_airline
    @airline = Airline.find(params[:airline_id])
  end

  def set_fleet_entry
    @fleet_entry = @airline.fleet_entries.find(params[:id])
  end

  def fleet_entry_params
    params.expect(fleet_entry: [:aircraft_variant_id, :fleet_count, :avg_age_years, :status])
  end
end
