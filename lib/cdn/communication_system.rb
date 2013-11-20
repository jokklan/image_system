require 'cdnconnect_api'

module CDN
  module CommunicationSystem

    CDN_APP_HOST = "benjamin.cdnconnect.com"
    CDN_API_KEY  = "1JQAmdOFpjLRq0P4qeYRRz79wOcjpkeKEiTa4GfHJ"

    class << self

      def upload(uuid, options = {})
        raise ArgumentError.new("uuid is not set") if uuid.blank?

        options = set_options(uuid, options)
        response = api_client.upload(options)

        # should look for the status from the message instead
        return_files = response.data["results"]["files"]
        if return_files.size == 1
          true
        end
      end

      private

      def api_client
        @cdn ||= CDNConnect::APIClient.new(app_host: CDN_APP_HOST, api_key: CDN_API_KEY)
      end

      def default_options
        {destination_path: '/'}
      end

      def set_options(uuid, options)
        options[:destination_file_name] = "#{uuid}.jpg"
        default_options.merge(options)
      end

    end
  end
end
