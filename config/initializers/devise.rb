Devise.setup do |config|
  require 'devise/orm/active_record'
  config.authentication_keys = [:username]
  config.case_insensitive_keys = [:username]
  config.strip_whitespace_keys = [:username]
  # config.default_scope = :user
  config.navigational_formats = []
  config.sign_out_via = :delete

  config.warden do |manager|
    manager.default_strategies(:scope => :user).unshift :ldap_authenticatable
  end

  config.jwt do |jwt|
    jwt.secret = ENV['VFEATURES_SECRET_KEY']
  end
end
