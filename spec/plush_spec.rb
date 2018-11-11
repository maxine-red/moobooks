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

conf = {
  maxine: {
    engine: 'markov',
    twitter: nil,
    mastodon: nil
  }
}
apps = {
  general: {
    consumer_key: '',
    consumer_secret: ''
  }
}

app = Moobooks::Plush.new('maxine', conf[:maxine], apps)

describe Moobooks::Plush, '#name' do
  it 'returns name of plush' do
    expect(app.name).to be_a String
  end
end

describe Moobooks::Plush, '#engine' do
  it 'returns engine of plush' do
    expect(app.engine).to be_a String
  end
end
