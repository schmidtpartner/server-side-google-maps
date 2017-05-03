# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "server-side-google-maps"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Hooper"]
  s.date = "2016-09-23"
  s.description = "Servers can use Google Maps, too. This library helps fetch and parse data through the Google Maps v3 API. Stick to the terms of usage, though, and don't use the data Google gives you on anything other than a Google map."
  s.email = ["adam@adamhooper.com"]
  s.executables = ["autospec", "htmldiff", "httparty", "ldiff", "rspec"]
  s.files = [".gitignore", "AUTHORS", "Gemfile", "LICENSE", "README.md", "Rakefile", "bin/autospec", "bin/htmldiff", "bin/httparty", "bin/ldiff", "bin/rspec", "lib/server-side-google-maps.rb", "lib/server-side-google-maps/directions.rb", "lib/server-side-google-maps/geo_math.rb", "lib/server-side-google-maps/path.rb", "lib/server-side-google-maps/point.rb", "lib/server-side-google-maps/route.rb", "lib/server-side-google-maps/segment.rb", "lib/server-side-google-maps/server.rb", "lib/server-side-google-maps/version.rb", "server-side-google-maps.gemspec", "spec/directions_spec.rb", "spec/files/directions-45.5086700,-73.5536800-to-45.4119000,-75.6984600.txt", "spec/files/directions-Montreal,QC-to-Ottawa,ON-without-distance.txt", "spec/files/directions-Montreal,QC-to-Ottawa,ON-without-overview-polyline.txt", "spec/files/directions-Montreal,QC-to-Ottawa,ON.txt", "spec/files/directions-Ottawa,ON-to-Toronto,ON.txt", "spec/files/path1-get_elevations-result.txt", "spec/path_spec.rb", "spec/point_spec.rb", "spec/route_spec.rb", "spec/segment_spec.rb", "spec/spec.rb"]
  s.homepage = "http://github.com/adamh/server-side-google-maps"
  s.require_paths = ["lib"]
  s.rubyforge_project = "server-side-google-maps"
  s.rubygems_version = "1.8.29"
  s.summary = "Performs calculations with Google Maps"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<nayutaya-googlemaps-polyline>, ["= 0.0.1"])
      s.add_development_dependency(%q<json>, ["= 1.8.1"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<nayutaya-googlemaps-polyline>, ["= 0.0.1"])
      s.add_dependency(%q<json>, ["= 1.8.1"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<nayutaya-googlemaps-polyline>, ["= 0.0.1"])
    s.add_dependency(%q<json>, ["= 1.8.1"])
  end
end
