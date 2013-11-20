require 'cdnconnect_api'

module CDN
  module CommunicationSystem

    CDN_APP_HOST = "benjamin.cdnconnect.com"
    CDN_API_KEY  = "1JQAmdOFpjLRq0P4qeYRRz79wOcjpkeKEiTa4GfHJ"

    class << self

      def upload(uuid, args)
        raise ArgumentError.new("uuid is not set") if uuid.blank?

        options = set_args(uuid,args)
        res = api_client.upload(options)

        # should look for the status from the message instead
        return_files = res.data["results"]["files"]
        if return_files.size == 1
          true
        end
      end

      def download(args)
        #response = api_client.get_object(:path => '/d772b5543df94134ae8d57c3f0884586.jpg')
      end

      private

      def api_client
        @cdn ||= CDNConnect::APIClient.new(:app_host => CDN_APP_HOST, :api_key => CDN_API_KEY)
      end

      def default_args
        {:destination_path => '/'}
      end

      def set_args(uuid, new_args)
        new_args[:destination_file_name] = "#{uuid}.jpg"
        default_args.merge(new_args)
      end

    end
  end
end
