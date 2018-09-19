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
                  'display_name, biography, location, '\
                  'homepage, created_at) VALUES ($1, $2, $3, $4, $5, $6, '\
                  '$7);',
                  [user.id, user.screen_name, user.name,
                   user.description, user.location, user.website.to_s,
                   user.created_at])
        end
        nil
      end
    end
  end
end
