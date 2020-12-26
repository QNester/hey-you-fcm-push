require 'spec_helper'

RSpec.describe HeyYouFcmPush::Connection do

  describe '#send_notification' do
    let!(:config) { HeyYou::Config.instance }
    let!(:token) { 'token' }
    let!(:reauth_token) { 'reauth_token' }
    let!(:stub_object) do
      AuthStubber.new(token, reauth_token)
    end

    before(:each) do
      allow(Google::Auth).to receive(:get_application_default).and_return(stub_object)

      HeyYou::Config.configure do
        config.splitter = '.'
        config.registered_channels = [:fcm_push]
        config.data_source.options = { collection_files: ['spec/fixtures/notifications.yml'] }
        config.fcm_push.credentials_file = "spec/fixtures/test-credentials.json"
        config.fcm_push.project_id = 'my-project-12345'
      end
    end

    let!(:message) do
      builder = HeyYou::Builder.new('rspec.test_notification_with_configs', pass_variable: FFaker::Lorem.word)

      HeyYouFcmPush::MessageObject.new(
        topic: builder.fcm_push.topic,
        notification: builder.fcm_push.notification,
        android: builder.fcm_push.android,
        webpush: builder.fcm_push.webpush,
        apns: builder.fcm_push.apns,
        fcm_options: builder.fcm_push.fcm_options,
        data: builder.fcm_push.push_data
      ).to_h
    end

    subject { described_class.instance.send_notification(message) }

    context 'success request' do
      it 'make request with body' do
        body = { message: message, validate_only: false }.to_json
        request = stub_request(:post, HeyYouFcmPush::Connection.instance.uri).with(
          body: body, headers: { Authorization: "Bearer #{token}", 'Content-Type': 'application/json' }
        ).to_return(status: 200, body: {}.to_json, headers: {})

        subject

        expect(request).to have_been_made
      end
    end

    context 'first request returns 401' do
      it 'make request after reauth' do
        body = { message: message, validate_only: false }.to_json
        request = stub_request(:post, HeyYouFcmPush::Connection.instance.uri).with(
          body: body, headers: { Authorization: "Bearer #{token}", 'Content-Type': 'application/json' }
        ).to_return(status: 401, body: {}.to_json, headers: {})

        request_after_reauth = stub_request(:post, HeyYouFcmPush::Connection.instance.uri).with(
          body: body, headers: { Authorization: "Bearer #{reauth_token}", 'Content-Type': 'application/json' }
        ).to_return(status: 200, body: {}.to_json, headers: {})

        subject

        expect(request).to have_been_made
        expect(request_after_reauth).to have_been_made
      end
    end
  end
end
