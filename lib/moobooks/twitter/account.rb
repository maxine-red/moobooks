# frozen_string_literal: true

# Copyright 2018 Maxine Michalski <maxine@furfind.net>
#
# This file is part of MooBooks.
#
# MooBooks is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MooBooks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MooBooks.  If not, see <http://www.gnu.org/licenses/>.

require 'oauth'

module Moobooks
  module Twitter
    class AccountNotFound < StandardError; end
    # @author Maxine Michalski
    # @since 0.1.0
    #
    # A class to handle Twitter accounts
    class Account
      # @author Maxine Michalski
      #
      # Create a new entry for a Twitter account
      #
      # @param user [Twitter::User] User information for account
      def self.create(user)
        Moobooks::Database.connect do |pg|
          pg.exec('INSERT INTO twitter.accounts (id, screen_name, '\
                  'display_name, description, location, '\
                  'website, created_at) VALUES ($1, $2, $3, $4, $5, $6, '\
                  '$7);',
                  [user.id, user.screen_name, user.name,
                   user.description, user.location, user.website.to_s,
                   user.created_at])
        end
        nil
      end

      # @author Maxine Michalski
      #
      # Generate an authorization token
      #
      # @param app [Moobooks::Twitter::App] App to authorize against
      #
      # @return [Oauth::RequestToken] Request token to authorize with
      def self.authorize(app)
        consumer = OAuth::Consumer.new(app.consumer_key,
                                      app.consumer_secret,
                                      site: 'https://twitter.com',
                                      scheme: :header)
        consumer.get_request_token
      end

      # @author Maxine Michalski
      #
      # Initializer for Account objects
      #
      # @param name [String] Screen name (@ handle) of account
      def initialize(name)
        account = Moobooks::Database.connect do |pg|
          pg.exec('SELECT id, plush_id, app_id, screen_name, display_name, '\
                  'description, location, website, access_token, '\
                  'access_token_secret, created_at, updated_at FROM '\
                  'twitter.accounts WHERE screen_name = $1;', [name]).first
        end
        raise AccountNotFound if account.nil?
        account.each do |k, v|
          if k == 'app_id'
            k = 'app'
            v = Moobooks::Twitter::App.new(v) unless v.nil?
          end
          if k == 'plush_id'
            k = 'plush'
            v = Moobooks::Plush.new(v) unless v.nil?
          end
          instance_variable_set("@#{k}", v)
        end
      end

      # @author Maxine Michalski
      #
      # Set the app this account got authorized with
      #
      # @param app [Moobooks::Twitter::App] App that was used to authorize this
      # account
      def app=(app)
        Moobooks::Database.connect do |pg|
          pg.exec('UPDATE twitter.accounts SET app_id = $2, '\
                  'updated_at = CURRENT_TIMESTAMP(0) WHERE id = $1;',
                  [@id, app.id])
        end
        @app = app
      end

      def access_token=(token)
        Moobooks::Database.connect do |pg|
          pg.exec('UPDATE twitter.accounts SET access_token = $2 '\
                  'updated_at = CURRENT_TIMESTAMP(0) WHERE id = $1;',
                  [@id, token])
        end
        @access_token = token
      end

      def access_token_secret=(secret)
        Moobooks::Database.connect do |pg|
          pg.exec('UPDATE twitter.accounts SET access_token_secret = $2 '\
                  'updated_at = CURRENT_TIMESTAMP(0) WHERE id = $1;',
                  [@id, secret])
        end
        @access_token_secret = secret
      end
    end
  end
end
