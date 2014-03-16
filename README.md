# Heroploy

[![Build Status](https://travis-ci.org/jbrunton/heroploy.png?branch=master)](https://travis-ci.org/jbrunton/heroploy)
[![Dependency Status](https://gemnasium.com/jbrunton/heroploy.png)](https://gemnasium.com/jbrunton/heroploy)
[![Code Climate](https://codeclimate.com/github/jbrunton/heroploy.png)](https://codeclimate.com/github/jbrunton/heroploy)
[![Coverage Status](https://coveralls.io/repos/jbrunton/heroploy/badge.png?branch=master)](https://coveralls.io/r/jbrunton/heroploy?branch=master)

A few helpful rake tasks to automate configuring and deploying to Heroku apps.

## Installation

Add this line to your application's Gemfile:

    gem 'heroploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroploy

## Usage

**See the [documentation](https://github.com/jbrunton/heroploy/wiki/) for a more detailed description of the options available for configuring and deploying with Heroploy.**


Add a ```heroploy.yml``` file to your application's config directory which describes the Heroku apps you will deploy to, and the checks you would like when deploying to each.

If you're running Rails, you can use this generator to add an example config file:

    rails generate heroploy:install
    
Here's an example ```heroploy.yml``` file:

```yaml
travis_repo: my-travis-user/my-travis-repo

environments:
  development:
    app: my-development-app

  staging:
    app: my-staging-app
    checks:
      pushed: true
      branch: master

  production:
    app: my-production-app
    tag: 'RELEASE_%Y%m%dT%H%M%S%z'
    checks:
      pushed: true
      branch: master
      staged: true
      travis: true
```

This file:

* Describes ```development```, ```staging``` and ```production``` deployment rules for three Heroku apps (named ```my-development-app```, ```my-staging-app``` and ```my-production-app``` on Heroku).
* Allows any branch to be pushed directly to ```development```.
* Only allows ```master``` to be pushed to ```staging```, and requires all changes to have first been pushed to ```origin```.
* Only allows deployment to ```production``` if the changes have first been staged on ```staging``` and the Travis build is passing.

To deploy to one of these environments, run ```rake heroploy:<environment>:deploy```.  For example:

    rake heroploy:production:deploy

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
