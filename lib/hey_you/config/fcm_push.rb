class HeyYou::Config::FcmPush
  extend HeyYou::Config::Configurable

  attr_accessor :credentials_file, :configured, :project_id

  def credentials_file=(filepath)
    @credentials_file = filepath
    ENV[Google::Auth::CredentialsLoader::ENV_VAR] = credentials_file
  end
end
