require 'cdnconnect_api'

module CDN
  module CommunicationSystem

    CDN_APP_HOST = "benjamin.cdnconnect.com"
    CDN_API_KEY  = "1JQAmdOFpjLRq0P4qeYRRz79wOcjpkeKEiTa4GfHJ"
    CDN_DEFAULT_JPEG_QUALITY = 95

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

      options = default_download_options.merge(options)
      params = set_aspect_options(options).to_param

      url = "http://#{CDN_APP_HOST}/#{uuid}.jpg"
      url = url + "?#{params}" unless params.empty?
      url
    end

    private

    def self.api_client
      @cdn ||= CDNConnect::APIClient.new(app_host: CDN_APP_HOST, api_key: CDN_API_KEY)
    end

    def self.default_upload_options
      { destination_path: '/' }
    end

    def self.default_download_options
      { quality: CDN_DEFAULT_JPEG_QUALITY, aspect: :original }
    end

    def self.set_upload_options(uuid, options)
      options[:destination_file_name] = "#{uuid}.jpg"
      default_upload_options.merge(options)
    end

    def self.set_aspect_options(options = default_download_options)
      aspect = options.delete(:aspect)
      options[:mode] = aspect == :original ?  "max" : "crop"
      options
    end

  end
end
