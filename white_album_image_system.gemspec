$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "image_system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "white_album_image_system"
  s.version     = ImageSystem::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = ["Bonnier Publications - Interactive"]
  s.homepage     = "https://github.com/BenjaminMedia/WhiteAlbum"
  s.summary      = "Image system for white album"
  s.description  = "It implements the functionalities a image system using CDN should have"

  s.require_path = 'lib'
  s.files      = Dir["{app,config,db,lib}/**/*", "Rakefile"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "cdnconnect-api"
  s.add_dependency "uuidtools"
  s.add_dependency "generator_spec"
end
