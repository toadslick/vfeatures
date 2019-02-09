require 'devise/jwt/test_helpers'

module TestHelpers

  def auth_headers(user, headers={})
    request.headers.merge! Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
