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

require 'pg'

module Moobooks
  # @author Maxine Michalski
  # @since 0.1.0
  #
  # A general purpose database connection module.
  #
  # @return Result of the given block
  module Database
    # @author Maxine Michalski
    #
    # Spawns a database connection and yields it
    #
    # @return object Result of the database block
    def self.connect
      pg = PG::Connection.new(dbname: 'moobooks')
      pg.type_map_for_results = PG::BasicTypeMapForResults.new(pg)
      result = yield pg
      pg.close
      result
    end
  end
end
