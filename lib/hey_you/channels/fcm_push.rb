require 'hey_you_fcm_push/connection'
require 'hey_you_fcm_push/message_object'

module HeyYou
  module Channels
    class FcmPush < Base
      class << self
        # Sending fcm message
        #
        # @param [HeyYou::Builder] builder - builder with notifications texts and settings
        # @option [String] name - Output Only. The identifier of the message sent
        # @option [String] token - Registration token to send a message to.
        # @option [String] to - Alias for `token`. `token` in high priority.
        # @option [String] topic - Topic name to send a message to, e.g. "weather".
        # @option [String] condition - Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
        # @option [Hash] notification - Basic notification template to use across all platforms.
        # @option [Hash] android - Android specific options for messages sent through FCM connection server.
        # @option [Hash] webpush - Webpush protocol options.
        # @option [Hash] apns - Apple Push Notification Service specific options.
        # @option [Hash] fcm_options - Platform independent options for features provided by the FCM SDKs.
        # @option [Hash] push_data - Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
        #
        # @return [Array{Hash}] - FCM responses
        #
        # @see: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#resource:-message
        def send!(builder, **options)
          options[:token] ||= options[:to]

          if options[:token].is_a?(Array)
            messages = options[:token].map { |token| build_message(builder, **options.merge(token: token)) }
          end

          messages ||= [build_message(builder, **options)]

          messages.map do |message|
            HeyYouFcmPush::Connection.instance.send_notification(message, validate_only: options[:validate_only])
          end
        end

        private

        def build_message(builder, **options)
          HeyYouFcmPush::MessageObject.new(
            token: options[:token],
            topic: options[:topic] || builder.fcm_push.topic,
            condition: options[:condition] || builder.fcm_push.condition,
            name: options[:name] || builder.fcm_push.name,
            notification: options[:notification] || builder.fcm_push.notification,
            android: options[:android] || builder.fcm_push.android,
            webpush: options[:webpush] || builder.fcm_push.webpush,
            apns: options[:apns] || builder.fcm_push.apns,
            fcm_options: options[:fcm_options]|| builder.fcm_push.fcm_options,
            data: options[:push_data] || builder.fcm_push.push_data
          ).to_h
        end
      end
    end
  end
end
