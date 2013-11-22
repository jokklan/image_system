require 'cdnconnect_api'

module CDN
  module CommunicationSystem

    CDN_APP_HOST = "benjamin.cdnconnect.com"
    CDN_API_KEY  = "1JQAmdOFpjLRq0P4qeYRRz79wOcjpkeKEiTa4GfHJ"

    def self.upload(options = {})
      uuid = options.delete(:uuid)
      raise ArgumentError.new("uuid is not set") if uuid.blank?

      options = set_upload_options(uuid, options)
      response = api_client.upload(options)

      # should look for the status from the message instead
      return_files = response.data["results"]["files"]
      if return_files.size == 1
        true
      end
    end

    def self.download(options = {})
      uuid = options.delete(:uuid)
      raise ArgumentError.new("uuid is not set") if uuid.blank?

      name = "#{uuid}"
      name = name + ".w#{options[:width]}" if options[:width]
      name = name + ".h#{options[:height]}" if options[:height]

      "http://#{CDN_APP_HOST}/#{name}.jpg"
    end

    private

    def self.api_client
      @cdn ||= CDNConnect::APIClient.new(app_host: CDN_APP_HOST, api_key: CDN_API_KEY)
    end

    def self.default_upload_options
      {destination_path: '/'}
    end

    def self.set_upload_options(uuid, options)
      options[:destination_file_name] = "#{uuid}.jpg"
      default_upload_options.merge(options)
    end

  end
end
