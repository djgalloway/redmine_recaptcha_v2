# Redmine reCAPTCHA v2 plugin

## Legacy

This is a fork of the srstclair's plugin (https://github.com/srstclair/redmine_recaptcha)

## About

Simple Redmine plugin to add a reCAPTCHA v2 to user self registration.

Relies on ambethia's reCAPTCHA plugin (https://github.com/ambethia/recaptcha)

## Requirements

Requires Redmine `3.4.0` or newer. Tested on version `3.4.3`.

## Installation

* Go to the Redmine's root directory
* Clone latest version of the plugin:<br>
  `git clone https://github.com/tallica/redmine_recaptcha_v2 plugins/redmine_recaptcha_v2`
* Run `bundle install` command to fetch `recaptcha` gem
* Restart Redmine
* Sign in as an administrator
* Go to `Administration` > `Plugins` > `Redmine reCAPTCHA v2 plugin` > `Configure`
* Go to the [reCAPTCHA website](https://www.google.com/recaptcha) and get the API keys (if you haven't already)
* Enter your Site and Secret Keys
* Go to self registration page to see captcha!

## Authors

Copyright (c) 2012 Shane R StClair<br>
Copyright (c) 2017 Michał Lipski

## License

Released under the [MIT](http://creativecommons.org/licenses/MIT/) license.
