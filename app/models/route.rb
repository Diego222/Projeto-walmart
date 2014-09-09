class Route < ActiveRecord::Base

  belongs_to :map

  def self.shortest(map_name, src, dst, autonomy, fuel_price)

    map_id = Map.where(name: map_name).first

    uniq_origins = Route.where(map_id: map_id).select(:origin).uniq
    uniq_destinations = Route.where('map_id = ? and destination not in (?)', map_id, uniq_origins.map(&:origin)).select(:destination).uniq

    all_map_routes = Route.where(map_id: map_id)

    graph = Graph.new

    uniq_origins.each { |origin_route| graph.push origin_route.origin }
    uniq_destinations.each { |destination_route| graph.push destination_route.destination }

    all_map_routes.each do |route|
      graph.connect_mutually route.origin, route.destination, route.distance
    end

    return_path = graph.dijkstra(src,dst)

    unless return_path.nil?
      return_path[:cost] = calculate_cost(return_path[:distance], autonomy.to_f, fuel_price.to_f)
    end

    return_path
  end

  private
  def self.calculate_cost(distance, autonomy, fuel_price)
    (distance / autonomy) * fuel_price
  end

end
