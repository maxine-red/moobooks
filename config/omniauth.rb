# Oniauth specific configuration

OmniAuth.config.logger = Rails.logger

module Moobooks
  class Application < Rails::Application
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
      config.session_options
  end
end
