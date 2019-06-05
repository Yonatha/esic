# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( estilos.css )
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( orobo/bootstrap.css )
Rails.application.config.assets.precompile += %w( orobo/style.css )
Rails.application.config.assets.precompile += %w( orobo/jquery.js )
Rails.application.config.assets.precompile += %w( orobo/jquery.mask.min.js )
Rails.application.config.assets.precompile += %w( orobo/bootstrap-tab.js )
Rails.application.config.assets.precompile += %w( jquery-3.2.1.min.js )
Rails.application.config.assets.precompile += %w( jquery-ui.min.js )
Rails.application.config.assets.precompile += %w( orobo/jquery-ui-1.css )