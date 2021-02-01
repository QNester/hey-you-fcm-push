require 'spec_helper'

RSpec.describe HeyYou::Builder::FcmPush do
  include_examples :have_readers, :topic, :condition, :name, :notification, :android, :webpush, :apns, :fcm_options, :push_data

  describe 'interpolation' do
    let!(:config) { HeyYou::Config.instance }

    before(:each) do
      config.splitter = '.'
      config.registered_channels = [:fcm_push]
      config.data_source.options = { collection_files: ['spec/fixtures/notifications.yml'] }
    end

    context 'interpolation variable passed' do
      let!(:interpolation_val) { FFaker::Lorem.word }
      subject { HeyYou::Builder.new('rspec.test_notification_with_configs', pass_variable: interpolation_val).fcm_push }

      it 'interpolate all notification keys' do
        expect(subject.notification['title']).not_to include('pass_variable')
        expect(subject.notification['body']).not_to include('pass_variable')
        expect(subject.android['notification']['title']).not_to include('pass_variable')
        expect(subject.android['notification']['body']).not_to include('pass_variable')
        expect(subject.webpush['notification']['title']).not_to include('pass_variable')
        expect(subject.webpush['notification']['body']).not_to include('pass_variable')
      end

      it 'interpolate_data' do

      end
    end

    context 'interpolation variable was not passed' do
      subject { HeyYou::Builder.new('rspec.test_notification_with_configs') }

      it { expect { subject }.to raise_error(HeyYou::Builder::FcmPush::InterpolationError) }
    end
  end
end
