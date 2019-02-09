require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def authenticate!
        if params[:user]
          ldap = Net::LDAP.new
          ldap.host = [ENV['VFEATURES_LDAP_HOST']]
          ldap.port = [ENV['VFEATURES_LDAP_PORT']]
          ldap.auth username, password

          if ldap.bind
            user = User.find_or_create_by(username: username)
            success!(user)
          else
            return fail(:invalid_login)
          end
        end
      end

      def username
        params[:user][:username]
      end

      def password
        params[:user][:password]
      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
