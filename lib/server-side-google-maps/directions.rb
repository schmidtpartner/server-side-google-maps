module ServerSideGoogleMaps
  class Directions
    LATLNG_STRING_REGEXP = /(-?\d+(\.?\d+)?),(-?\d+(\.?\d+)?)/

    def self.get(params)
      server = Server.new
      server.get('/maps/api/directions', {:sensor => false}.merge(params))
    end

    # Initializes directions
    #
    # Parameters:
    # origin: string or [lat,lng] of the first point
    # destination: string or [lat,lng] of the last point
    # params:
    #   :mode: :driving, :bicycling and :walking will be passed to Google Maps.
    #          Another option, :direct, will avoid in-between points and calculate
    #          the distance using the Haversine formula. Defaults to :driving.
    #   :find_shortcuts: [ {:factor => Float, :mode => :a_mode}, ... ]
    #                    For each list item (in the order given), determines if
    #                    using given :mode will cut the distance to less than
    #                    :factor and if so, chooses it. For example, if :mode is
    #                    :bicycling and there's a huge detour because of a missing
    #                    bike lane, pass { :factor => 0.5, :mode => :driving }
    #                    and if a shortcut cuts the distance in half that route
    #                    will be chosen instead.
    #   :waypoints: Array [ String or [lat,lng] ]
    #               With this optional parameter set, Google Maps will set a route leg for each waypoint
    #               in the given order.
    #   :optimize:  Boolean
    #               Tell Google Maps to optimize the given waypoints if set to true.
    #               This option refers to the Traveling Salesman Problem (TSP).
    #               The optimized order can be accessed by the returned key 'waypoint_order' within
    #               the returned route.
    def initialize(origin, destination, params = {})
      @origin = origin
      @destination = destination
      params = params.dup
      find_shortcuts = params.delete(:find_shortcuts) || []
      raise ArgumentError.new(':find_shortcuts must be an Array') unless Array === find_shortcuts
      @direct = params[:mode] == :direct
      params[:mode] = :driving if params[:mode] == :direct || params[:mode].nil?

      origin = origin.join(',') if Array === origin
      destination = destination.join(',') if Array === destination

      unless params[:waypoints].nil?
        params[:waypoints] = params[:waypoints].map { |wp| wp.is_a?(Array) ? wp.join(',') : wp }
        params[:waypoints] = params[:waypoints].join('|') unless params[:waypoints].is_a?(String)
        if params[:optimize] == true
          params[:waypoints] = 'optimize:true|' + params[:waypoints]
          params.delete(:optimize) || false
        end
      end

      unless @direct && origin_point_without_server && destination_point_without_server
        @data = self.class.get(params.merge(:origin => origin, :destination => destination))
      end

      if !@direct
        find_shortcuts.each do |try_shortcut|
          factor = try_shortcut[:factor]
          mode = try_shortcut[:mode]

          other = Directions.new(origin, destination, params.merge(:mode => mode))
          if other.distance.to_f / distance < factor
            @path = other.path
            @distance = other.distance
          end
        end
      end
    end

    def origin_input
      @origin
    end

    def destination_input
      @destination
    end

    def origin_address
      leg['start_address']
    end

    def destination_address
      leg['end_address']
    end

    def origin_point
      @origin_point ||= origin_point_without_server || Point.new(leg['start_location']['lat'], leg['start_location']['lng'])
    end

    def destination_point
      @destination_point ||= destination_point_without_server || Point.new(leg['end_location']['lat'], leg['end_location']['lng'])
    end

    def status
      @data['status']
    end

    def errors
      @data['error_message']
    end

    ## todo-matteo: distance returns distance of first leg only
    def distance
      @distance ||= calculate_distance
    end

    def path
      @path ||= Path.new(points)
    end

    def routes
      @data['routes']
    end

    private

    def points # DEPRECATED
      @points ||= calculate_points
    end

    def origin_point_without_server
      calculate_point_without_server_or_nil(origin_input)
    end

    def destination_point_without_server
      calculate_point_without_server_or_nil(destination_input)
    end

    def calculate_point_without_server_or_nil(input)
      return input if Array === input
      m = LATLNG_STRING_REGEXP.match(input)
      return Point.new(m[1].to_f, m[3].to_f) if m
    end

    def route
      @data['routes'].first
    end

    def leg
      route['legs'].first
    end

    def points_and_levels
      @points_and_levels ||= calculate_points_and_levels
    end

    def calculate_points_and_levels
      polyline = route['overview_polyline']
      return [ [origin_point.latitude, origin_point.longitude, 0], [destination_point.latitude, destination_point.longitude, 0]] unless polyline && polyline['points'] && polyline['levels']
      ::GoogleMapsPolyline.decode_polyline(polyline['points'], polyline['levels'])
    end

    def calculate_points
      return [ origin_point, destination_point ] if @direct
      points = points_and_levels.map { |lat,lng,level| Point.new(lat, lng) }
      points
    end

    def calculate_distance
      if @direct
        path.calculate_distances unless path.points[0].distance_along_path
        return path.points[-1].distance_along_path
      end
      if !leg['distance']
        return leg['steps'].collect{|s| s['distance']}.collect{|d| d ? d['value'].to_i : 0}.inject(0){|s,v| s += v}
      end
      leg['distance']['value']
    end
  end
end
