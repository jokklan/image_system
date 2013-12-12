class Image

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
  include ActiveModel::Validations
  include ImageSystem::Image

  def initialize(**args)
    self.uuid = args[:uuid]
    self.path = args[:path]
  end

end

class Response

  attr_accessor :status

  def initialize(**args)
    self.status = args[:status]
  end

end
