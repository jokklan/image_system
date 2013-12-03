require 'cdn/communication_system'

module ImageSystem
  module Image

    def save
      CDN::CommunicationSystem.upload(uuid: self.uuid, source_file_path: self.path, queue_processing: false)
      super
    end

  end
end
