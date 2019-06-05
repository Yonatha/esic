require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsProject
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.autoload_paths += %W(#{config.root}/lib) # add this line

    # config.i18n.default_locale = :'pt-BR'

    config.autoload_paths += %W(#{config.root}/lib)


    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_options = {from: 'you-email@gmail.com'}
    config.quiet_assets = false
    config.action_mailer.smtp_settings = {
        address: 'smtp.gmail.com',
        port: 587,
        user_name: 'you-email@gmail.com',
        password: '123456789',
        authentication: 'plain',
        enable_starttls_auto: true
    }
  end
end
