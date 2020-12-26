module HeyYouFcmPush
  class MessageObject
    class Notification
      TRANSLATED_KEYS = %w[title body]

      attr_reader :to_h
      def initialize(title:, body:, image: nil)
        @to_h = {
          title: title,
          body: body,
          image: image
        }.compact
      end
    end
  end
end
