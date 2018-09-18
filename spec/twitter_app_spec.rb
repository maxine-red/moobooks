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

describe Moobooks::Twitter::App, '.create' do
  context 'a consumer key and secret are given' do
    it 'saves them in a database' do
      pg = double(PG::Connection)
      expect(pg).to receive(:exec).and_return(true)
      expect(Moobooks::Database).to receive(:connect).and_yield(pg)
      expect(Moobooks::Twitter::App.create('', '1', '1')).to be nil
    end
  end
  context 'an empty consumer key and secret are given' do
    it 'raises an argument error' do
      expect { Moobooks::Twitter::App.create('', '', '') }.to(
        raise_error(ArgumentError)
      )
    end
  end
end

describe Moobooks::Twitter::App, '.list' do
  it 'returns an array of Twitte::App objects' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test' }]
    allow(pg).to receive(:exec).and_return(data, data)
    allow(Moobooks::Database).to receive(:connect).and_yield(pg)
    list = Moobooks::Twitter::App.list
    expect(list).to be_an Array
    expect(list.first).to be_a Moobooks::Twitter::App
  end
end

describe Moobooks::Twitter::App, '#to_s' do
  it 'returns a string representation of an App' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Twitter::App.new(1)
    expect(app.to_s).to be_a String
    expect(app.to_s).to eq '1 test'
  end
end

describe Moobooks::Twitter::App, '#id' do
  it 'returns app id' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Twitter::App.new(1)
    expect(app.id).to be_an Integer
  end
end

describe Moobooks::Twitter::App, '#name' do
  it 'returns app name' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Twitter::App.new(1)
    expect(app.name).to be_a String
  end
end

describe Moobooks::Twitter::App, '#consumer_key' do
  it 'returns consumer key of app' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test', 'consumer_key' => 't' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Twitter::App.new(1)
    expect(app.consumer_key).to be_a String
  end
end

describe Moobooks::Twitter::App, '#consumer_secret' do
  it 'returns consumer secret of app' do
    pg = double(PG::Connection)
    data = [{ 'id' => 1, 'name' => 'test', 'consumer_secret' => 't' }]
    expect(pg).to receive(:exec).and_return(data)
    expect(Moobooks::Database).to receive(:connect).and_yield(pg)
    app = Moobooks::Twitter::App.new(1)
    expect(app.consumer_secret).to be_a String
  end
end
