require_relative 'message_object/android_config'
require_relative 'message_object/apns_config'
require_relative 'message_object/fcm_options'
require_relative 'message_object/notification'
require_relative 'message_object/web_push_config'

module HeyYouFcmPush
  class MessageObject
    attr_reader :name, :receiver_hash, :android_config, :apns_config, :fcm_options,
                :notification, :push_data, :web_push_config

    # @option [String] name - Output Only. The identifier of the message sent
    # @option [String] token - Registration token to send a message to.
    # @option [String] topic - Topic name to send a message to, e.g. "weather".
    # @option [String] condition - Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
    # @option [Hash] notification - Basic notification template to use across all platforms.
    # @option [Hash] android - Android specific options for messages sent through FCM connection server.
    # @option [Hash] webpush - Webpush protocol options.
    # @option [Hash] apns - Apple Push Notification Service specific options.
    # @option [Hash] fcm_options - Platform independent options for features provided by the FCM SDKs.
    # @option [Hash] data - Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
    #
    # @see https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#resource:-message
    def initialize(name: nil, token: nil, topic: nil, condition: nil, **options)
      @receiver_hash = { token: token } if token
      @receiver_hash = { topic: topic } if topic
      @receiver_hash = { condition: condition } if condition

      raise PushReceiverError, "You should pass `token` or `topic` or `condition`" unless receiver_hash

      @name = name
      @notification = Notification.new(**options[:notification].transform_keys(&:to_sym)) if options[:notification]
      @android_config = AndroidConfig.new(options[:android].transform_keys(&:to_sym)) if options[:android_config]
      @web_push_config = WebPushConfig.new(options[:webpush].transform_keys(&:to_sym)) if options[:web_push_config]
      @apns_config = ApnsConfig.new(options[:apns].transform_keys(&:to_sym)) if options[:apns_config]
      @fcm_options = FcmOptions.new(**options[:fcm_options].transform_keys(&:to_sym)) if options[:fcm_options]
      @push_data = { data: options[:data].to_json }
    end

    def to_h
      {
        name: name,
        data: push_data,
        notification: notification&.to_h,
        android_config: android_config&.to_h,
        web_push_config: web_push_config&.to_h,
        apns_config: apns_config&.to_h,
        fcm_options: fcm_options&.to_h
      }.merge(receiver_hash).compact
    end

    class PushReceiverError < StandardError; end
  end
end
