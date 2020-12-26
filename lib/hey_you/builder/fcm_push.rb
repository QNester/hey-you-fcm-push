require 'hey_you_fcm_push/message_object'

module HeyYou
  class Builder
    class FcmPush < Base
      attr_reader :topic, :condition, :name, :notification, :android, :webpush, :apns, :fcm_options, :push_data

      NOTIFICATION_KEYS = HeyYouFcmPush::MessageObject::Notification::TRANSLATED_KEYS.map(&:to_s).freeze

      def build
        @topic = ch_data.fetch('topic', nil)
        @condition = ch_data.fetch('condition', nil)
        @name = ch_data.fetch('name', nil)

        @notification = interpolate_notification(ch_data.fetch('notification', nil))

        @android = interpolate_notification(ch_data.fetch('android', nil))
        @webpush = interpolate_notification(ch_data.fetch('webpush', nil))
        @apns = interpolate_notification(ch_data.fetch('apns', nil))
        @fcm_options = interpolate_notification(ch_data.fetch('fcm_options', nil))
        @push_data = ch_data.fetch('push_data', nil)
      end

      def interpolate_notification(data)
        return unless data

        interpolate_notification(data['notification']) if data['notification']
        NOTIFICATION_KEYS.each {  |k| data[k] = interpolate(data[k], options) if data[k] }

        data
      end
    end
  end
end
