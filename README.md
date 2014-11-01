# littleBits Travis Webhook

## Prerequisites

- [Git](http://git-scm.com)
- A [Heroku](https://heroku.com) account and the [Heroku Command Line Interface](https://devcenter.heroku.com/articles/heroku-command)
- A project using [Travis CI](https://travis-ci.org)

## Setup

### Create the littleBits Circuit

Follow the directions here: <http://littlebits.cc/projects/ci-status-lights>

### Get your CloudBit's Access Token and Device ID

You can view them on the Settings page of the [CloudBit Control Panel](<http://control.littlebitscloud.cc>)

### Get your Travis CI User Token

### Generate the HTTP Authentication value

    $ irb
    require 'digest/sha2'
    repo_slug = "<your_username>/<your_reponame>"
    user_token = "<your_travis_user_token>"
    Digest::SHA2.new.update(repo_slug + user_token).to_s

### Create and configure the Heroku webhook app

    $ git clone https://github.com/spilth/littlebits-travis-webhook.git
    $ cd littlebits-travis-webhook
    $ heroku login
    $ heroku create
    $ heroku config:set CLOUDBIT_ACCESS_TOKEN=<your_access_token>
    $ heroku config:set CLOUDBIT_DEVICE_ID=<your_device_id>
    $ heroku config:set TRAVIS_USER_TOKEN=<your_user_token>
    $ heroku config:set HTTP_TRAVIS_REPO_SLUG=<your_repo_slug>
    $ heroku config:set HTTP_AUTHENTICATION=<your_http_authentication>
    $ git push heroku master

### Configure the Travis CI webhook in your project

Add the following to your `.travis.yml` to send a notification to your Heroku app:

    notifications:
      webhooks:
        - https://your-heroku-app.heroku.com/

Now kick off a build and watch the green LED turn on.

Or red LED if your build is failing!
