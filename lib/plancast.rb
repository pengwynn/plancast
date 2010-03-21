require 'httparty'
require 'hashie'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Plancast
  
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