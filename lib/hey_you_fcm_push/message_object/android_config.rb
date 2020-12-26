module HeyYouFcmPush
  class MessageObject
    class AndroidConfig
      attr_reader :to_h

      def initialize(**options)
        options[:fcm_options] = options[:fcm_options]&.transform_keys(&:to_sym)
        options[:notification] = options[:notification]&.transform_keys(&:to_sym)

        @to_h = {
          collapse_key: options[:collapse_key],
          priority: options[:priority],
          ttl: options[:ttl],
          restricted_package_name: options[:restricted_package_name],
          data: options[:data],
          notification: build_notification(options[:notification]),
          fcm_options: (
            FcmOptions.new(analytics_label: options[:fcm_options][:analytics_label]).to_h if options[:fcm_options]
          ),
          direct_boot_ok: options[:direct_boot_ok]
        }.compact
      end

      def build_notification(notification)
        return if !notification || notification == {}

        {
          title: notification[:title],
          body: notification[:body],
          icon: notification[:icon],
          color: notification[:color],
          sound: notification[:sound],
          tag: notification[:tag],
          click_action: notification[:click_action],
          body_loc_key: notification[:body_loc_key],
          body_loc_args: notification[:body_loc_args],
          title_loc_key: notification[:title_loc_key],
          title_loc_args: notification[:title_loc_args],
          channel_id: notification[:channel_id],
          ticker: notification[:ticker],
          sticky: notification[:sticky],
          event_time: notification[:event_time],
          local_only: notification[:local_only],
          notification_priority: notification[:notification_priority],
          default_sound: notification[:default_sound],
          default_vibrate_timings: notification[:default_vibrate_timings],
          default_light_settings: notification[:default_light_settings],
          vibrate_timings: notification[:vibrate_timings],
          visibility: notification[:visibility],
          notification_count: notification[:notification_count],
          light_settings: notification[:light_settings],
          image: notification[:image]
        }.compact
      end
    end
  end
end
