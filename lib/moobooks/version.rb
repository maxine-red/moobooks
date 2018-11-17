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

# Namespace for all classes in this gem.
# @author Maxine Michalski
# @since 0.1.0
module Moobooks
  MAJOR = 0
  MINOR = 3
  PATCH = 1
  NAME = 'moobooks'
  VERSION = "#{MAJOR}.#{MINOR}.#{PATCH}"
  DESCRIPTION = 'A framework and CLI to create and manage ebook '\
                "accounts.\nKeep in mind that actual accounts need to "\
                'be created manually, but can be linked with this tool.'
end
