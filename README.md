# Hey, You, FCM!
[![Build Status](https://travis-ci.com/QNester/hey-you-fcm-push.svg?branch=master)](https://travis-ci.com/QNester/hey-you-fcm-push#)[![Gem Version](https://badge.fury.io/rb/hey-you-fcm-push.svg)](https://badge.fury.io/rb/hey-you-fcm-push)

Send Nexmo sms via [hey-you gem](https://github.com/QNester/hey-you). This gem depended on [nexmo-ruby](https://github.com/Nexmo/nexmo-ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey-you-nexmo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey-you-nexmo

## Usage

After load gem you can send Nexmo SMS via [hey-you](https://github.com/QNester/hey-you).

For example:
```yaml
# config/notifications.yml
events:
  verified_code:
    # ...
    nexmo:
      text: 'Your verification code: %{code}'
      from: 'bestNumber'
      is_unicode: false # has priority above this setting in config
```

```ruby
# config/initalizers/hey-you.rb
HeyYou::Config.configure do 
  # [String] required - your sender number 
  config.nexmo.from = 'myNumber'

  # [Nexmo::Client] required - Instance of Nexmo client (check https://github.com/Nexmo/nexmo-ruby for more info)
  config.nexmo.client = Nexmo::Client.new(...)
  
  # [Boolean] optional - If you will send unicode texts
  config.nexmo.is_unicode = true
  
  # [Block] optional - Response handle (block which accept Nexmo::Response object)
  config.nexmo.response_hander = proc { |response| CheckActualBalanceJob.perform_async(response.http_response.body) }
  
  # Check https://developer.nexmo.com/api/sms#delivery-receipt for more info about settings below
  config.nexmo.ttl = 90000
  config.nexmo.status_report_req = true
  config.nexmo.callback = 'http://my_callback.url/'
end
```

```ruby
# // somewhere in your app 
builder = Builder.new('events.verified_code', code: verified_code) 
HeyYou::Channels::Nexmo.send!(builder, to: receiver_phone_number) #=> { success: true }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
