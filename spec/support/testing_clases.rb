class Image

  attr_accessor :uuid

  def initialize(**args)
    self.uuid = args[:uuid]
  end

  def save
    super_save_is_called
  end

  def destroy
    super_destroy_is_called
  end

  def super_save_is_called
  end

  def super_destroy_is_called
  end

end

class Photo < Image
  include ImageSystem::Image

end

class Response
  def status
    nil
  end
end
