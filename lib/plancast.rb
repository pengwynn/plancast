require 'httparty'
require 'hashie'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Plancast
  
  VERSION = "0.1.2".freeze
  
  def self.configure
    yield self
    true
  end
  
  def self.api_url(endpoint, version = self.api_version)
    "http://api.plancast.com/#{version}#{endpoint}.json"
  end

  
  def self.api_version
    @api_version || "02"
  end
  
  def self.api_version=(value)
    @api_version = value
  end
  
  class PlancastError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end
  
  class ClientError < StandardError; end
  class ServerError < PlancastError; end
  class General     < PlancastError; end
  
  class Unauthorized      < ClientError; end
  class NotFound          < ClientError; end

  class Unavailable   < StandardError; end
end

require File.join(directory, 'plancast', 'client')