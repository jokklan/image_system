require 'cdn/communication_system'
require 'exceptions/cdn_upload_exception'

module ImageSystem
  module Image

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
