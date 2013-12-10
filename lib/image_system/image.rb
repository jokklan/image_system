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
        # should log the problem
        return false
      end
    end

    def destroy
      begin
        response = self.new_record? ? true : CDN::CommunicationSystem.delete(uuid: self.uuid)
        super if response
      rescue Exceptions::CdnUnknownException => e
        # should log the problem
        return false
      end
    end

    def url
      self.new_record? ? nil : CDN::CommunicationSystem.download(uuid: self.uuid)
    end

  end
end
