$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "image_system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "image_system"
  s.version     = ImageSystem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = ["Bonnier Publications - Interactive"]
  s.email       = ["feedback@benjamin.dk"]
  s.homepage    = "https://github.com/BenjaminMedia/WhiteAlbum"
  s.summary     = "Image system for rails apps"
  s.description = "It implements the functionalities a image system should have"

  s.rubyforge_project = "image_system"

  s.files      = Dir["{app,config,db,lib}/**/*", "Rakefile"]
  s.test_files = Dir["spec/**/*"]
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "cdnconnect-api"
  s.add_development_dependency "uuidtools"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock",'~> 1.15.2'
end
