class Image

  attr_accessor :uuid

  def initialize(**args)
    self.uuid = args[:uuid]
  end

  def new_record?
  end

  def save
    super_saved_is_called
  end

  def super_saved_is_called
  end

end

class Photo < Image
  include ImageSystem::Image

end
