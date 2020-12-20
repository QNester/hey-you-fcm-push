require 'hey-you'
require_relative 'hey_you_fcm_push/version'
require_relative 'hey_you/config/fcm_push'
require_relative 'hey_you/builder/fcm_push'
require_relative 'hey_you/channels/fcm_push'

module HeyYouFcmPush
  CHANNEL_NAME = 'fcm_push'.freeze

  HeyYou::Config.instance.registrate_channel(CHANNEL_NAME)
end
