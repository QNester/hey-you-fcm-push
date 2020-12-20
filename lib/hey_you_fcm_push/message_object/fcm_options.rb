module HeyYouFcmPush
  class MessageObject
    class FcmOptions
      attr_reader :to_h

      def initialize(analytics_label:, link: nil, image: nil)
        @to_h = {
          analytics_label: analytics_label,
          link: link,
          image: image
        }.compact
      end
    end
  end
end
