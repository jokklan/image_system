require 'uuidtools'

module LibHelpers
  def create_uuid
    UUIDTools::UUID.random_create.to_s.gsub(/\-/, '')
  end

  def test_image_path
    "#{Rails.root}/public/images/test_image.jpg"
  end
end

RSpec.configure do |config|
  config.include LibHelpers
end
