module ImageSystem
  module Image

    attr_accessor :uuid, :path

    def self.included(base)
      base.class_eval do
        validates_presence_of :uuid
      end
    end

    def save
      rescue_from_cdn_failure do
        if self.new_record? || self.changed.include?("uuid")
          CDN::CommunicationSystem.upload(uuid: self.uuid, source_file_path: self.path, queue_processing: false)
        end
        super
      end
    end

    def destroy
      rescue_from_cdn_failure do
        response = self.new_record? ? true : CDN::CommunicationSystem.delete(uuid: self.uuid)
        super if response
      end
    end

    def url
      self.new_record? ? nil : CDN::CommunicationSystem.download(uuid: self.uuid)
    end

    private

    def rescue_from_cdn_failure(&block)
      begin
        block.call
      rescue Exceptions::CdnResponseException => e
        # should log the problem
        return false
      rescue Exceptions::CdnUnknownException => e
        # should log the problem
        return false
      end
    end

  end
end
