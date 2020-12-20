module HeyYouFcmPush
  class MessageObject
    class WebPushConfig
      attr_reader :to_h

      def initialize(**options)
        hash = {
          headers: options[:headers],
          data: options[:data],
          notification: (Notification.new(**options[:notification].to_h) if options[:notification]),
        }

        if options[:fcm_options]
          hash.merge(
            fcm_options: FcmOptions.new(
              analytics_label: options[:fcm_options][:analytics_label],
              link: options[:fcm_options][:link]
            ).to_h
          )
        end

        @to_h = hash
      end
    end
  end
end
