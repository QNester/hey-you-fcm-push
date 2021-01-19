require 'spec_helper'

RSpec.describe HeyYou::Channels::FcmPush do
  describe '#send!' do
    let!(:config) { HeyYou::Config.instance }

    before(:each) do
      config.splitter = '.'
      config.registered_channels = [:fcm_push]
      config.data_source.options = { collection_files: ['spec/fixtures/notifications.yml'] }
    end

    let!(:options) { {} }
    let!(:notification_key) { 'rspec.test_notification_with_configs' }
    let!(:builder) { HeyYou::Builder.new(notification_key, pass_variable: FFaker::Lorem.word) }
    subject { described_class.send!(builder, **options) }

    before do
      stub = double(Google::Auth, apply!: true)
      allow(Google::Auth).to receive(:get_application_default).and_return(stub)
    end

    context 'with options' do
      let!(:options) do
        {
          token: token,
          name: SecureRandom.uuid,
          notification: {
            title: FFaker::Lorem.words(4),
            body: FFaker::Lorem.sentence
          },
          android: {
            notification: {
              title: FFaker::Lorem.words(4),
              body: FFaker::Lorem.sentence,
              tag: FFaker::Lorem.word
            },
            priority: 'HIGH'
          },
          apns: {
            headers: {}
          },
          webpush: {
            notification: {
              title: FFaker::Lorem.words(4),
              body: FFaker::Lorem.sentence,
            }
          },
          fcm_options: {
            analytics_label: 'label'
          },
          push_data: {
            hello: :world
          }
        }
      end

      context 'with one token' do
        let!(:token) { SecureRandom.uuid }

        it 'send notification via HeyYouFcmPush::Connection' do
          message = HeyYouFcmPush::MessageObject.new(
            token: options[:token],
            topic: options[:topic] || builder.fcm_push.topic,
            condition: options[:condition],
            name: options[:name],
            notification: options[:notification],
            android: options[:android],
            webpush: options[:webpush],
            apns: options[:apns],
            fcm_options: options[:fcm_options],
            data: options[:push_data]
          ).to_h
          expect(HeyYouFcmPush::Connection.instance).to receive(:send_notification).with(message, validate_only: nil)
          subject
        end
      end

      context 'with token arrays' do
        let!(:token) { [SecureRandom.uuid, SecureRandom.uuid] }

        it 'send notification via HeyYouFcmPush::Connection to each token' do
          token.each do |t|
            message = HeyYouFcmPush::MessageObject.new(
              token: t,
              topic: options[:topic] || builder.fcm_push.topic,
              condition: options[:condition],
              name: options[:name],
              notification: options[:notification],
              android: options[:android],
              webpush: options[:webpush],
              apns: options[:apns],
              fcm_options: options[:fcm_options],
              data: options[:push_data]
            ).to_h

            expect(HeyYouFcmPush::Connection.instance).to receive(:send_notification).ordered.with(message, validate_only: nil).once
          end

          subject
        end
      end
    end

    context 'without options' do
      let!(:options) { {} }

      it 'send notification via HeyYouFcmPush::Connection' do
        message = HeyYouFcmPush::MessageObject.new(
          topic: builder.fcm_push.topic,
          notification: builder.fcm_push.notification,
          android: builder.fcm_push.android,
          webpush: builder.fcm_push.webpush,
          apns: builder.fcm_push.apns,
          fcm_options: builder.fcm_push.fcm_options,
          data: builder.fcm_push.push_data
        ).to_h
        expect(HeyYouFcmPush::Connection.instance).to receive(:send_notification).with(message, validate_only: nil)
        subject
      end

      context 'without any receiver data' do
        let!(:notification_key) { 'rspec.test_notification_without_receiver' }

        it { expect { subject }.to raise_error(HeyYouFcmPush::MessageObject::PushReceiverError) }
      end
    end
  end
end
