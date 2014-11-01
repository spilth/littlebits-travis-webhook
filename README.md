# littleBits Travis Webhook

## Prerequisites

- A [Heroku](https://heroku.com) account
- A project that's using [Travis CI](https://travis-ci.org)
- [Ruby](https://www.ruby-lang.org/en/) to generate an authentication code for your webhook
- [Git](http://git-scm.com) and the [Heroku Toolbelt](https://toolbelt.heroku.com) if you want to manually create your Heroku app

## Setup

### Create the littleBits Circuit

Follow the directions here: <http://littlebits.cc/projects/ci-status-lights>

### Get your CloudBit's Access Token and Device ID

You can view them on the Settings page of the [CloudBit Control Panel](<http://control.littlebitscloud.cc>)

### Get your Travis CI User Token

You can find it on your [Travis CI Profile Page](https://travis-ci.org/profile/info).

### Get your Travis CI Repository Slug

This will be `your_username/your_repo_name`. For example: `spilth/littlebits-travis-webhook` for this repository.

### Generate your Travis CI Authentication Value

This will be used by the webhook to confirm status updates came from Travis CI:

    $ irb
    require 'digest/sha2'
    repo_slug = "<your_username>/<your_reponame>"
    user_token = "<your_travis_user_token>"
    Digest::SHA2.new.update(repo_slug + user_token).to_s

### Create and configure the Heroku app

The easiest way to this is by using this button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Or, to create your Heroku app manually:

    $ git clone https://github.com/spilth/littlebits-travis-webhook.git
    $ cd littlebits-travis-webhook
    $ heroku login
    $ heroku create <your-heroku-app-name>
    $ heroku config:set CLOUDBIT_ACCESS_TOKEN=<your_access_token>
    $ heroku config:set CLOUDBIT_DEVICE_ID=<your_device_id>
    $ heroku config:set TRAVIS_USER_TOKEN=<your_user_token>
    $ heroku config:set HTTP_TRAVIS_REPO_SLUG=<your_repo_slug>
    $ heroku config:set HTTP_AUTHENTICATION=<your_http_authentication>
    $ heroku config:set BASIC_USERNAME=<username_for_testing>
    $ heroku config:set BASIC_PASSWORD=<password_for_testing>
    $ git push heroku master

### Test your webook

You can test your webhook instance by going to the following two URLs:

- <https://your-heroku-app-name.heroku.com/success>
- <https://your-heroku-app-name.heroku.com/failure>

You'll be prompted for a username and password. Use the BASIC ones you configured above.

### Configure the Travis CI webhook in your project

Add the following to your `.travis.yml` to send a notification to your Heroku app:

    notifications:
      webhooks:
        - https://your-heroku-app-name.heroku.com/

Now kick off a build and watch the green LED turn on.

Or red LED if your build is failing!
