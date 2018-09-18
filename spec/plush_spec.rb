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

describe Moobooks::Plush, '.create' do
  context 'a valid name and engine is given' do
    it 'creates a databse entry' do
      pg = double(PG::Connection)
      expect(pg).to receive(:exec).and_return(true)
      expect(Moobooks::Database).to receive(:connect).and_yield(pg)
      expect(Moobooks::Plush.create('test', 'rng')).to be nil
    end
  end
  context 'an empty name paramets is given' do
    it 'raises an ArgumentError' do
      expect { Moobooks::Plush.create('', '') }.to raise_error ArgumentError
    end
  end
  context 'an unsupported engine type is given' do
    it 'raises an UnsupportedEngineError' do
      expect { Moobooks::Plush.create('1', '') }.to(
        raise_error Moobooks::UnsupportedEngineError
      )
    end
  end
end

describe Moobooks::Plush, '.list' do
  it 'returns an array of Twitte::App objects' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test' }]
    allow(pg).to receive(:exec).and_return(data, data)
    allow(Moobooks::Database).to receive(:connect).and_yield(pg)
    list = Moobooks::Plush.list
    expect(list).to be_an Array
    expect(list.first).to be_a Moobooks::Plush
  end
end

describe Moobooks::Twitter::App, '#to_s' do
  it 'returns a string representation of an App' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test', 'engine' => 'rng' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Plush.new(1)
    expect(app.to_s).to be_a String
    expect(app.to_s).to(
      eq '1 test rng | not active | can\'t favorite | can\'t reblog'
    )
  end
end
