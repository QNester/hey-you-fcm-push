require 'googleauth'
require 'hey_you/config/fcm_push'

module HeyYouFcmPush
  class Connection
    include Singleton

    URL_TMPL = "https://fcm.googleapis.com/v1/projects/%{project_id}/messages:send".freeze
    AUTH_SCOPES = ['https://www.googleapis.com/auth/firebase.messaging'].freeze
    RETRY_COUNT = 1
    HTTP_CODES = {
      not_auth: 401,
      success: 200
    }

    attr_reader :authorization, :options, :project_id, :uri

    def initialize
      @authorization = Google::Auth.get_application_default(AUTH_SCOPES)
      @options = { headers: { 'Content-Type': 'application/json' } }
      @project_id = HeyYou::Config::FcmPush.instance.project_id
      @uri = URL_TMPL % { project_id: project_id }

      reauth
    end

    def send_notification(message, validate_only: false, retry_count: 0)
      request_options = options.clone
      request_options[:body] = { message: message, validate_only: validate_only }.to_json

      make_request(uri, request_options)
    rescue AuthError => e
      retry_count += 1
      raise e if retry_count > RETRY_COUNT

      reauth
      return send_notification(message, validate_only: validate_only, retry_count: retry_count + 1)
    end

    def reauth
      authorization.apply!(options[:headers])
    end

    private

    def make_request(uri, **request_options)
      response = HTTParty.post(uri, request_options)
      binding.pry
      process_response(response)
    end

    def process_response(response)
      raise AuthError if response.code == HTTP_CODES[:not_auth]
      return response.to_hash if response.code == HTTP_CODES[:success]

      raise ResponseError, "response code: #{response.code}"
    end

    class AuthError < StandardError; end
    class ResponseError < StandardError; end
  end
end