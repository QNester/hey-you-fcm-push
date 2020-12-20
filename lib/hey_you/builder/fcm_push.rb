module HeyYou
  class Builder
    class FcmPush < Base
      attr_reader :topic, :condition, :name, :notification, :android, :webpush, :apns, :fcm_options, :push_data

      def build
        @topic = ch_data.fetch(:topic, nil)
        @condition = ch_data.fetch(:condition, nil)
        @name = ch_data.fetch(:name, nil)
        @notification = ch_data.fetch(:notification, nil)
        @android = ch_data.fetch(:android, nil)
        @webpush = ch_data.fetch(:webpush, nil)
        @apns = ch_data.fetch(:apns, nil)
        @fcm_options = ch_data.fetch(:fcm_options, nil)
        @push_data = ch_data.fetch(:push_data, nil)
      end
    end
  end
end
