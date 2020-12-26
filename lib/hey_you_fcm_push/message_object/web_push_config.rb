module HeyYouFcmPush
  class MessageObject
    class WebPushConfig
      attr_reader :to_h

      def initialize(headers: nil, data: nil, notification: nil, fcm_options: nil)
        notification = notification&.transform_keys(&:to_sym)
        fcm_options = fcm_options&.transform_keys(&:to_sym)

        hash = {
          headers: headers,
          data: data,
          notification: (Notification.new(**notification).to_h if notification),
        }

        if fcm_options
          hash.merge(
            fcm_options: FcmOptions.new(analytics_label: fcm_options[:analytics_label], link: fcm_options[:link]).to_h
          )
        end

        @to_h = hash.compact
      end
    end
  end
end
