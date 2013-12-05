module ImageSystem
  module Image

    attr_accessor :path

    def save
      begin
        if self.new_record? || self.changed.include?("uuid")
          CDN::CommunicationSystem.upload(uuid: self.uuid, source_file_path: self.path, queue_processing: false)
        end
        super
      rescue Exceptions::CdnUploadException => e
        return false
      end
    end

  end
end
