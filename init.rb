require 'recaptcha'
require 'recaptcha/rails'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'account_controller'
  require_dependency 'account_controller_patch'
  AccountController.send(:include, AccountControllerPatch)
end

Redmine::Plugin.register :redmine_recaptcha_v2 do
  name 'Redmine reCAPTCHA v2 plugin'
  author 'Shane StClair and Michał Lipski'
  description "Adds a reCAPTACHA to Redmine's user self registration screen to combat spam"
  version '0.2.0'
  url 'https://github.com/tallica/redmine_recaptcha_v2'
  requires_redmine :version_or_higher => '3.3.0'
  settings(
    :default => {
      'site_key' => '',
      'secret_key' => ''
    },
    :partial => 'settings/redmine_recaptcha_v2'
  )
end
