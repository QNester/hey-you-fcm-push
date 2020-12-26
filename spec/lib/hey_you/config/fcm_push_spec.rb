require 'spec_helper'

RSpec.describe HeyYou::Config::FcmPush do
  before do
    described_class.instance.instance_variable_set(:@configured, false)
  end

  include_examples :singleton

  describe 'attributes' do
    include_examples :have_accessors, :credentials_file, :project_id
  end

  describe 'credentials_file=' do
    before { ENV[Google::Auth::CredentialsLoader::ENV_VAR] = nil }
    after { ENV[Google::Auth::CredentialsLoader::ENV_VAR] = nil }

    let!(:filepath) { '/file/path' }

    subject do
      HeyYou::Config::FcmPush.instance.credentials_file = filepath
    end

    it 'set ENV variable' do
      expect(ENV[Google::Auth::CredentialsLoader::ENV_VAR]).to be_nil
      subject
      expect(ENV[Google::Auth::CredentialsLoader::ENV_VAR]).to eq(filepath)
    end
  end

  describe 'configure' do
    context 'not pass required config' do
      before do
        Singleton.__init__(HeyYou::Config::FcmPush)
      end

      subject { HeyYou::Config.configure {} }

      it 'raise error `RequiredConfigsNotPassed`' do
        expect { subject }.to raise_error(HeyYou::Config::Configurable::RequiredConfigsNotPassed)
      end
    end
  end
end
