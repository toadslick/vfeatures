require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        if params[:user]
          username = params[:user][:username].downcase.chomp
          password = params[:user][:password]
          return fail!(:invalid_login) if password.blank?
          if auth_via_ldap(username, password)
            user = User.find_or_create_by(username: username)
            success!(user)
          else
            fail!(:invalid_login)
          end
        end
      end

      def auth_via_ldap(username, password)

        # TODO: delete this line before releasing to production.
        return true if Rails.env.development? || Rails.env.test?

        email = username + '@' + ENV['VFEATURES_LDAP_DOMAIN']
        ldap = Net::LDAP.new
        ldap.host = ENV['VFEATURES_LDAP_HOST']
        ldap.port = ENV['VFEATURES_LDAP_PORT']
        ldap.auth email, password
        ldap.bind
      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
