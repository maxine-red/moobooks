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
    #
    # A class to handle Twitter apps.
    class App
      # @author Maxine Michalski
      #
      # Create a new app, by storing it's credentials into databse.
      #
      # @param name [String] Name of the app
      def self.create(name)
        puts 'You can find both consumer key and consumer secret in '\
             'your app page.',
             'If you haven\'t created an app yet, you need to create '\
             'one on Twitter.'
        print 'Consumer key: '
        consumer_key = $stdin.gets.chomp
        print 'Consumer secret: '
        consumer_secret = $stdin.gets.chomp
        Moobooks::Database.connect do |pg|
          pg.exec('INSERT INTO twitter.apps (name, consumer_key, '\
                  'consumer_secret) VALUES ($1, $2, $3);',
                  [name, consumer_key, consumer_secret])
        end
      end
    end
  end
end
