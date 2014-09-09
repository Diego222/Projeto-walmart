class MapsController < ApplicationController

  def index
    @maps = Map.all
  end

  

  def create
    attributes = map_params
    routes_attributes = attributes.delete("routes")
    @map = Map.where(name: attributes[:name]).first_or_initialize
    @map.routes += routes_attributes.map { |r| Route.new(r)}
    respond_to do |format|
      if @map.save
        format.json { render json: @map, status: :created }
      else
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @map = Map.find(map_params)
  end

  def destroy
    respond_to do |format|
      if @map.destroy
        format.json { head :no_content, status: :ok }
      else
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def map_params
    json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
    json_params.permit(:name, :routes => [:origin, :destination, :distance])
  end

end