# Heroploy

[![Build Status](https://travis-ci.org/jbrunton/heroploy.png?branch=master)](https://travis-ci.org/jbrunton/heroploy)
[![Code Climate](https://codeclimate.com/github/jbrunton/heroploy.png)](https://codeclimate.com/github/jbrunton/heroploy)

A few helpful rake tasks to manage deploying Rails apps to development, staging and production Heroku servers.

## Installation

Add this line to your application's Gemfile:

    gem 'heroploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroploy

## Usage

Add a .heroploy file in your application's root directory which describes the Heroku apps you will deploy to, and the c

```yaml
apps:
  development:
    heroku: my-app-development

  staging:
    heroku: my-app-staging
    checks:
      pushed: true
      branch: master

  production:
    heroku: my-app-production
    tag: 'RELEASE_%Y%m%dT%H%M%S%z'
    checks:
      pushed: true
      branch: master
      staged: true
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
