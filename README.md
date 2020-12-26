# Hey, You, FCM!
[![Build Status](https://travis-ci.com/QNester/hey-you-fcm-push.svg?branch=master)](https://travis-ci.com/QNester/hey-you-fcm-push#)[![Gem Version](https://badge.fury.io/rb/hey-you-fcm-push.svg)](https://badge.fury.io/rb/hey-you-fcm-push)

Send fcm pushes via [hey-you gem](https://github.com/QNester/hey-you) using [google fcm protocol](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey-you-fcm-push'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey-you-fcm-push

## Usage

After load gem you can send FCM pushes via [hey-you](https://github.com/QNester/hey-you).

For example:
```yaml
# config/notifications.yml
events:
  say_hello:
    # ...
    fcm_push:
      topic: 'users_topic'
      notification:
        title: 'Hey!'
        body: 'Hey, %{name}!'
      android:
        notification:
          title: 'Hey, Android'
          body: 'Hey, %{name}!'
      webpush:
        notification:
          title: 'Hey, Webpush'
          body: 'Hey, %{name}!'
      apns:
        payload:
          hello: 'world'
      fcm_options:
        analytics_label: label
      push_data:
        hello: 'world'
```
*More about format: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages*

```ruby
# config/initalizers/hey-you.rb
HeyYou::Config.configure do
  # ... base hey-you configuration ...
  
  # FCM project_id
  config.fcm_push.project_id = 'my-project-12345'
  
  # Google FCM server credentials file
  config.fcm_push.credentials_file = '/path/to/credentials.json'
end
```

```ruby
# // somewhere in your app 
builder = HeyYou::Builder.new('events.say_hello', name: "Jonny") 
HeyYou::Channels::FcmPush.send!(builder, token: 'token') #=> { message_id: 'message_id' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To run tests execute `make test`.

To install this gem onto your local machine, run `bundle exec rake install`.
