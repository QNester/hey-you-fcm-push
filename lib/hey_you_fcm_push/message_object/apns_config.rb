module HeyYouFcmPush
  class MessageObject
    class ApnsConfig
      attr_reader :to_h

      def initialize(headers: nil, payload: nil, fcm_options: nil)
        hash = { headers: headers, payload: payload }

        if fcm_options
          hash.merge!(
            fcm_options: FcmOptions.new(analytics_label: fcm_options[:analytics_label], image: fcm_options[:image]).to_h
          )
        end

        @to_h = hash
      end
    end
  end
end
