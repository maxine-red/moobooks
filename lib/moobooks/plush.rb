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

require 'moo_ebooks'
require 'twitter'

module Moobooks
  class UnsupportedEngineError < StandardError; end
  # @author Maxine Michalski
  # @since 0.1.0
  #
  # Plushies!
  class Plush
    # @return [String] Name of current toy
    attr_reader :name

    # @return [String] Engine this plush is running on
    attr_reader :engine

    # @return [Ebooks::Model] Model used by this plush
    attr_reader :model

    # @return [Hash] Names of original accounts
    attr_reader :originals

    attr_reader :twitter_client
    # @author Maxine Michalski
    #
    # Initializer for Plushies
    #
    # @param name [String] Name of new plush
    # @param conf [Hash] Configuration hash
    # @param apps [Hash] Hash that contains available app configurations
    #
    # @notice Engine can be `rng` or `markov` only.
    def initialize(name, conf, apps)
      raise ArgumentError, 'Name can\'t be empty~' if name.nil? || name.empty?
      @name = name
      @engine = conf[:engine]
      raise UnsupportedEngineError unless %w[rng markov].include?(@engine)
      @originals = {}
      twitter_login(apps, conf[:twitter]) unless conf[:twitter].nil?
      add_dnp_words(conf)
      @model = Ebooks::Model.from_json(
        File.read("#{__dir__}/../../models/#{@name}.json")
      )
    end

    # @author Maxine Michalski
    #
    # Method to post statuses to all available social platforms
    def post_status!
      @status = 'trap'
      @status = @model.update(280) while @status =~ /#{@bad_words.join('|')}/
      @twitter_client&.update(@status)
      @status
    end
    
    # @author Maxine Michalski
    #
    # Let's this plush reply to messages.
    #
    # @notice This can cause endless reply loops, use with caution!
    def reply!(status)
      return if replied?(status)
      @status = 'trap'
      while @status =~ /#{@bad_words.join('|')}/
        @status = @model.reply(status.text, 200)
      end
      @twitter_client&.update("@#{status.user.screen_name} #{@status}",
                              in_reply_to_status: status)
      @status
    end

    # @author Maxine Michalski
    #
    # Returns a hash of all connected clients
    #
    # @return [Hash] Hash of different, connected, clients
    def clients
      clients = {}
      clients.store(:twitter, @twitter_client) unless @twitter_client.nil?
      clients
    end

    private

    def replied?(status)
      return true if Time.now - status.created_at > 900
      if File.exist?("#{__dir__}/../../replies/#{@name}.json")
        ids = JSON.parse(File.read("#{__dir__}/../../replies/#{@name}.json"))
        replied = ids.include?(status.id)
        unless replied
          ids << status.id
          ids = ids.to_json
          File.write("#{__dir__}/../../replies/#{@name}.json", ids)
        end
        replied
      else
        ids = [status.id].to_json
        File.write("#{__dir__}/../../replies/#{@name}.json", ids)
        return false
      end
    end

    def add_dnp_words(conf)
      @bad_words = %w[swastika genocide behead trap dead death woadedfox]
      @bad_words += conf[:dnp] unless conf[:dnp].nil?
    end

    def twitter_login(apps, conf)
      app = apps[conf[:api].to_sym]
      @twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key = app[:consumer_key]
        config.consumer_secret = app[:consumer_secret]
        config.access_token = conf[:access_token]
        config.access_token_secret = conf[:access_token_secret]
      end
      @originals.store(:twitter, conf[:original])
    end
  end
end
