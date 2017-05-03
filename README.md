# Server-Side Google Maps: map data from Google, for your server

Make requests for direction from Google's servers, and receive them in a
Ruby-usable object.

## Installation and usage

To install:

    sudo gem install server-side-google-maps

Then, to use within Ruby:

    route = ServerSideGoogleMaps::Route.new(['Montreal, QC', 'Ottawa, ON'], :mode => :driving)
    # Origin and destination accept [lat,lon] coordinates as well as strings
    # :mode => :driving is the default. Others are :bicycling and :walking

    route.status              # 'OK'
    route.origin_address      # 'Montreal, QC, Canada'
    route.origin_point        # [ 45.5086700, -73.5536800 ]
    route.destination_address # 'Ottawa, ON, Canada'
    route.destination_point   # [ 45.4119000, -75.6984600 ]
    route.path.points         # Array of Point coordinates of route
    route.points[0].latitude  # .latitude, .longitude, .distance_to_here
    route.distance            # 199901 (metres)

    # We can also find elevations along a path
    path = route.path
    path.elevations(20) # Array of equidistant Points, each with an elevation
    # Paths used for elevation may only be up to around 230 points long,
    # to comply with Google's URL length limit. That's not hard to achieve:
    simple_path = path.interpolate(230) # will create a new Path by interpolating

One final `:mode` is `:direct`, which calculates `points` and estimates
`distance` without querying Google. To ensure Google isn't queried, input
the origin and destination as latitude/longitude coordinates.

### Optional parameters for use of Google Maps' Direction service

    'waypoints':    This parameter accepts an Array of Addresses or Coordinates.
                    Addresses have to be Strings, e.g. 'Montreal, QC'.
                    Coordinates have to be Arrays of type [lat,lng], e.g. [1.57,-72.55].
                    Google will process and return the waypoints in the given order by default.

    'optimize':     Tell Google Maps to optimize the given waypoints if set to true.
                    This will change the order of the given waypoints.
                    The optimized order can be accessed by the returned key 'waypoint_order' within the returned route.
                    This option refers to the Traveling Salesman Problem (TSP).

    'language':     Tell Google Maps to return all waypoint descriptions and units in a specific language.
                    Refer to https://developers.google.com/maps/faq#languagesupport for a selection of languages.

    'key':          Hand over your api key to Google Maps.

Example to use within Ruby:

    request_params = {
              :waypoints => ['Charlestown,MA','Lexington,MA'],
              :optimize => true,
              :language => 'de',
              :key => 'yourApiKey'
          }
    directions = ServerSideGoogleMaps::Directions.new('Montreal, QC, Canada','Ottawa, ON, Canada',request_params)

    directions.status              # 'OK'
    directions.errors              # nil
    directions.origin_address      # 'Montreal, QC, Canada'
    directions.origin_point        # [ 45.5086700, -73.5536800 ]
    directions.destination_address # 'Ottawa, ON, Canada'
    directions.destination_point   # [ 45.4119000, -75.6984600 ]
    directions.routes              # [ { :legs => [...], :overview_polyline => '...', :waypoint_order => [ ... ], ... }, {...} ]


## Limitations

As per the Google Maps API license agreement, the data returned from the
Google Maps API must be used only for display on a Google Map.

I'll write that again: Google Maps data is for Google Maps only! You may not
do any extra calculating and processing, unless the results of those extra
calculations are displayed on a Google Map.

There are also query limits on each Google API, on the order of a few thousand
queries each day. Design your software accordingly. (Cache heavily and don't
query excessively.)

## Development

Each feature and issue must have a spec. Please write specs if you can.
