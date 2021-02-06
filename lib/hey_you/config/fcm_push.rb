class HeyYou::Config::FcmPush
  extend HeyYou::Config::Configurable

  attr_accessor :credentials_file, :project_id

  REQUIRED_CONFIGS = %i[credentials_file project_id]

  def credentials_file=(filepath)
    ENV[Google::Auth::CredentialsLoader::ENV_VAR] = filepath
  end

  def validate_config
    @credentials_file = ENV[Google::Auth::CredentialsLoader::ENV_VAR]
    return if REQUIRED_CONFIGS.all? { |conf| send(conf) }

    raise(
      HeyYou::Config::Configurable::RequiredConfigsNotPassed,
      "You must pass all required config for channel `fcm_push`: #{REQUIRED_CONFIGS}"
    )
  end
end
