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

module Moobooks
  module Twitter
    # @author Maxine Michalski
    # @since 0.1.0
    class AppNotFound < StandardError; end
    # @author Maxine Michalski
    # @since 0.1.0
    #
    # A class to handle Twitter apps.
    class App
      # @return [Integer] ID of this app
      attr_reader :id

      # @return [String] Name of this app
      attr_reader :name

      # @return [String] Consumer key of this app
      attr_reader :consumer_key

      # @return [String] Consumer secret of this app
      attr_reader :consumer_secret
      # @author Maxine Michalski
      #
      # Create a new app, by storing it's credentials into databse.
      #
      # @param name [String] Name of the app
      # @param consumer_key [String] Twitter app consumer key
      # @param consumer_secret [String] Twitter app consumer secret
      def self.create(name, consumer_key, consumer_secret)
        if consumer_key.empty? || consumer_secret.empty?
          raise ArgumentError, 'Consumer data can\'t be empty.'
        end
        Moobooks::Database.connect do |pg|
          pg.exec('INSERT INTO twitter.apps (name, consumer_key, '\
                  'consumer_secret) VALUES ($1, $2, $3);',
                  [name, consumer_key, consumer_secret])
        end
        nil
      end

      # @author Maxine Michalski
      #
      # Creates a list of all Twitter apps in database
      #
      # @return [Array<Moobooks::Twitter::App>] A list Twitter apps
      def self.list
        apps = Moobooks::Database.connect do |pg|
          pg.exec('SELECT id FROM twitter.apps ORDER BY id;').to_a
        end
        apps.map do |a|
          Moobooks::Twitter::App.new(a['id'])
        end
      end

      # @author Maxine Michalski
      #
      # Initializer for Twitter appps
      #
      # @param id [Integer] The ID of an app we want to fetch
      def initialize(id)
        app = Moobooks::Database.connect do |pg|
          pg.exec('SELECT id, name, consumer_key, consumer_secret, '\
                  'created_at FROM twitter.apps WHERE id = $1;', [id]).first
        end
        raise AppNotFoundError if app.nil?
        app.each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end

      # @author Maxine Michalski
      #
      # Turn this App into a string representation
      #
      # @notice The returned string will be in the form of '<id> <name>'
      #
      # @return [String] A formatted string representation of this App
      def to_s
        "#{@id} #{@name}"
      end
    end
  end
end
