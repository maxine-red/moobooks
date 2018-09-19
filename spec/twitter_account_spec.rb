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

describe Moobooks::Twitter::Account, '.authorize' do
  it 'returns an authorization url and request token' do
    # actually mock and stuff
  end
end

describe Moobooks::Twitter::Account, '.tokenize' do
  it 'takes a pin and authentication token and returns an access token' do
    # mock and stuff
  end
end

describe Moobooks::Twitter::Account, '.create' do
  it 'takes a Twitter::User object and '\
    'creates a new account entry in database' do
    u = Twitter::User.new(id: 1, screen_name: 't', name: 't',
                          description: 't', location: 't',
                          homepage: 'http://example.org',
                          created_at: Time.now.to_s)
    pg = double(PG::Connection)
    expect(pg).to receive(:exec).and_return(true)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    expect(Moobooks::Twitter::Account.create(u)).to be nil
  end
end
