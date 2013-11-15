require 'cdnconnect_api'

module CDN
  module CommunicationSystem

    CDN_APP_HOST = "benjamin.cdnconnect.com"
    CDN_API_KEY  = "1JQAmdOFpjLRq0P4qeYRRz79wOcjpkeKEiTa4GfHJ"

    class << self

      private

      def set_api_client
        @cdn ||= CDNConnect::APIClient.new(:app_host => CDN_APP_HOST, :api_key => CDN_API_KEY)
      end

    end
  end
end
