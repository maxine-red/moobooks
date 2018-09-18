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
  class UnsupportedEngineError < StandardError; end
  class PlushNotFoundError < StandardError; end
  # @author Maxine Michalski
  # @since 0.1.0
  #
  # Plushies!
  class Plush
    # @return [integer] ID of current plush
    attr_reader :id

    # return [String] Name of current toy
    attr_reader :name

    # return [String] Engine this plush is running on
    attr_reader :engine

    # @return [Time] Time of creation for current toy
    attr_reader :created_at

    # @author Maxine Michalski
    #
    # Class method to create Plushies in database
    #
    # @param name [String] Name of new plush
    # @param engine [String] Engine the plush is running on
    #
    # @notice Engine can be `rng` or `markov` only.
    def self.create(name, engine)
      raise ArgumentError, 'Name can\'t be empty~' if name.empty?
      raise UnsupportedEngineError unless %w[rng markov].include?(engine)
      Moobooks::Database.connect do |pg|
        pg.exec('INSERT INTO plushies (name, engine) VALUES ($1, $2);',
                [name, engine])
      end
      nil
    end

    # @author Maxine Michalski
    #
    # Lists all known plushies
    #
    # @return [Array<Moobooks::Plush>] A list of plush toys
    def self.list
      plushs = Moobooks::Database.connect do |pg|
        pg.exec('SELECT id FROM plushies ORDER BY id;').to_a
      end
      plushs.map do |plush|
        Moobooks::Plush.new(plush['id'])
      end
    end

    # @author Maxine Michalski
    #
    # Initializer for Plushies
    #
    # @param plush [Integer,String] Name or ID of a plush to fetch
    def initialize(plush)
      plush = Moobooks::Database.connect do |pg|
        pg.exec('SELECT id, name, engine, is_active, can_favorite, '\
                'can_reblog, created_at FROM plushies WHERE '\
                "#{plush.is_a?(String) ? 'name' : 'id'} = $1", [plush]).first
      end
      raise PlushNotFoundError if plush.nil?
      plush.each do |k, v|
        k = k.sub(/is_|can_/, '')
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
      "#{@id} #{@name} #{@engine} | #{@active ? 'active' : 'not active'}"\
      " | #{@favorite ? 'can favorite' : 'can\'t favorite'}"\
      " | #{@reblog ? 'can reblog' : 'can\'t reblog'}"
    end

    # @author Maxine Michalski
    #
    # Activate current toy
    def activate!
      Moobooks::Database.connect do |pg|
        pg.exec('UPDATE plushies SET is_active = TRUE WHERE id = $1;', [@id])
      end
      @active = true
      nil
    end

    # @author Maxine Michalski
    #
    # Deactivate current toy
    def deactivate!
      Moobooks::Database.connect do |pg|
        pg.exec('UPDATE plushies SET is_active = FALSE WHERE id = $1;', [@id])
      end
      @active = false
      nil
    end

    # @author Maxine Michalski
    #
    # Shows if a plush is active or not
    #
    # @return [Boolean] Activation status of plush
    def active?
      @active
    end
  end
end
