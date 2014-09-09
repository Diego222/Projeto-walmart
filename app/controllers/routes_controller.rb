class RoutesController < ApplicationController

  def index
    @routes = Route.where(map_id: params[:map_id])
    #@routes = Route.all
  end

  def shortest
    @shortest = Route.shortest(params[:map_name], params[:src], params[:dst], params[:autonomy], params[:fuel_price])
  end

 
  private   

  def route_params
    params.require(:route).permit(:map_name, :src, :dst, :autonomy,:fuel_price)
  end


end